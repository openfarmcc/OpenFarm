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
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'webmock/rspec'
require 'vcr'
require 'pundit/rspec'
# ====== PHANTOMJS stuff
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true)
end
# =====
Delayed::Worker.delay_jobs = false
# ===== VCR stuff (records HTTP requests for playback)
VCR.configure do |c|
  c.cassette_library_dir = 'vcr'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options = { record: :new_episodes,
                                 match_requests_on: [:host, :method] }
  c.ignore_hosts '127.0.0.1', 'localhost', 'localhost:9200'
  # c.allow_http_connections_when_no_cassette = true
end
# =====

Paperclip.options[:log] = false

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
  config.fail_fast = true
  config.order = "random"
  if ENV['DOCS'] == 'true'
    DocYoSelf.config do |c|
      c.template_file = 'spec/template.md.erb'
      c.output_file   = 'api_docs.md'
    end

    config.after(:each, type: :controller) do
      DocYoSelf.run!(request, response) if request.url.include?('/api/')
    end

    config.after(:suite) { DocYoSelf.finish! }
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
  include Devise::TestHelpers
end