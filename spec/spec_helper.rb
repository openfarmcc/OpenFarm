# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'config/initializers/rack-attack.rb'
  add_filter 'config/environment.rb'
  add_filter 'config/initializers/mongoid.rb'
  add_filter 'config/initializers/backtrace_silencers.rb'
  add_filter 'spec/'
end
require File.expand_path("../../config/environment", __FILE__)
# SEE: https://github.com/rails/rails/issues/18572
require 'test/unit/assertions'
# =====
require 'rspec/rails'
require 'capybara/rails'
require 'webmock/rspec'
require 'vcr'
require 'webmock/rspec'
require 'pundit/rspec'
# ====== PHANTOMJS stuff
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 90)
  Capybara::Poltergeist::Driver.new(app, js_errors: true)
  Capybara::Poltergeist::Driver.new(app, :phantomjs => Phantomjs.path)
end
# =====
Delayed::Worker.delay_jobs = false
# ===== VCR stuff (records HTTP requests for playback)
VCR.configure do |c|
  c.cassette_library_dir = 'vcr'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options = { record: :new_episodes,
                                 match_requests_on: [:host, :method] }
  c.ignore_localhost = true
  c.ignore_request do |request|
    URI(request.uri).port == 9200
  end
  # c.allow_http_connections_when_no_cassette = true
end
# =====

Paperclip.options[:log] = false

require 'database_cleaner'

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Mongoid.logger.level = 2
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ApiHelpers, type: :controller
  config.include IntegrationHelper, type: :feature
  config.include Capybara::DSL
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.fail_fast = false
  config.order = "random"
  if ENV['DOCS'] == 'true'
    SmarfDoc.config do |c|
      c.template_file = 'spec/template.md.erb'
      c.output_file   = 'api_docs.md'
    end

    config.after(:each, type: :controller) do
      SmarfDoc.run!(request, response) if request.url.include?('/api/')
    end

    config.after(:suite) { SmarfDoc.finish! }
  end
  config.before :each do
    Guide.reindex
    Crop.reindex
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
