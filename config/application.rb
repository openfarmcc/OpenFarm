# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
Bundler.require(:default, Rails.env)

module OpenFarm
  class Application < Rails::Application
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = %w[en]
    config.i18n.default_locale = :'en'
    config.i18n.fallbacks = %i[en]

    config.assets.initialize_on_precompile = false
    # Include all JS files, also those in subdolfer or javascripts assets folder
    # includes for exmaple applicant.js. JS isn't the problem so the catch all works.
    config.assets.precompile += %w[*.js]
    # https://github.com/FortAwesome/font-awesome-sass/issues/48
    config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif *.svg *.ico *.eot *.ttf *.woff *.woff2]
    # Replace %w( *.css *.js *.css.scss) with complex regexp avoiding SCSS partials compilation
    config.assets.precompile += [/^[^_]\w+\.(css|css.scss)$/]
    # Adding active_admin JS and CSS to the precompilation list
    config.assets.precompile += %w[active_admin.css active_admin.js active_admin/print.css]
    config.secret_key_base = ENV['SECRET_KEY_BASE']
    config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
      allow do
        origins '*'
        resource '/api/v1/*',
                 # No cookies.
                 headers: :any, methods: %i[get post delete put patch options head], credentials: false, max_age: 0
      end
    end
    config.middleware.use Rack::Attack

    config.generators { |g| g.orm :mongoid }
  end
end
