require File.expand_path('../boot', __FILE__)
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
Bundler.require(:default, Rails.env)

module OpenFarm
  class Application < Rails::Application
    I18n.enforce_available_locales = false
    config.i18n.fallbacks = [:en]

    config.assets.initialize_on_precompile = false
    # Include all JS files, also those in subdolfer or javascripts assets folder
    # includes for exmaple applicant.js. JS isn't the problem so the catch all works.
    config.assets.precompile += %w(*.js)
    # Replace %w( *.css *.js *.css.scss) with complex regexp avoiding SCSS partials compilation
    config.assets.precompile += [/^[^_]\w+\.(css|css.scss)$/]
    # Adding active_admin JS and CSS to the precompilation list
    config.assets.precompile += %w( active_admin.css active_admin.js active_admin/print.css )
    config.secret_key_base = ENV['SECRET_KEY_BASE']
    config.middleware.insert_before 'ActionDispatch::Static', 'Rack::Cors' do
      allow do
        origins '*'
        resource '/api/*',
                 headers: :any,
                 methods: [:get, :post, :delete, :put, :patch, :options, :head],
                 credentials: false, # No cookies.
                 max_age: 0
      end
    end
    config.middleware.use Rack::Attack
    config.after_initialize do
      Crop.reindex
    end
  end
end

