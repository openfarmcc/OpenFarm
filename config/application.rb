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
    # Precompile *all* assets, except those that start with underscore
    config.assets.precompile << /(^[^_\/]|\/[^_])[^\/]*$/
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
  end
end
