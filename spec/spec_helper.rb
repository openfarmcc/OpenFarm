# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'webmock/rspec'
require 'vcr'
# ====== PHANTOMJS stuff
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true)
end
# =====

# ===== VCR stuff (records HTTP requests for playback)
VCR.configure do |c|
  c.cassette_library_dir = 'vcr'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options = { record: :none,
                                 match_requests_on: [:host, :method] }
end
# =====

require 'database_cleaner'
Capybara.javascript_driver = :poltergeist
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Mongoid.logger.level = 2
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ApiHelpers, type: :controller
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end