# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.7'

gem 'bundler'
gem 'rails'

# We can't upgrade to Mongoid 7 unless someone has
# time to manually QA the failed view specs that
# it causes. -RC 15 MAR 19
gem 'mongoid', '~> 6'

gem 'delayed_job_mongoid' # <= Problematic dep upgrade
gem 'delayed_job_shallow_mongoid'
gem 'kaminari-mongoid'
gem 'mongoid-history'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mongoid-slug'
gem 'mongoid_taggable'

gem 'active_model_serializers'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'bson_ext'

gem 'searchkick'

gem 'coffee-rails'
gem 'devise'
gem 'eventmachine'
gem 'exception_notification'
gem 'high_voltage'
gem 'jsonapi-serializers'
gem 'merit'
gem 'mutations'
gem 'platform-api'
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'rails_admin'
gem 'rollbar'
gem 'sass-rails'
gem 'utf8-cleaner'

# Asset management using bower
# https://rails-assets.org/
source 'https://rails-assets.org' do
  gem 'rails-assets-angular', '1.5.8'
  gem 'rails-assets-angular-dragdrop', '~> 1.0'
  gem 'rails-assets-angular-foundation', '~> 0.8'
  gem 'rails-assets-angular-local-storage', '~> 0.2'
  gem 'rails-assets-angular-sanitize', '1.5.8'
  gem 'rails-assets-angular-typeahead', '~> 0.3'
  gem 'rails-assets-angular-ui-sortable', '~> 0.13'
  gem 'rails-assets-jquery', '~> 2.1'
  gem 'rails-assets-jquery-ui', '~> 1.11'
  gem 'rails-assets-moment', '2.24.0'
  gem 'rails-assets-ng-file-upload', '~> 12.2'
  gem 'rails-assets-ng-tags-input', '~> 3.2'
  gem 'rails-assets-showdown', '~> 1.9'
end

gem 'font-awesome-sass'

gem 'autoprefixer-rails'
gem 'foundation-rails'

gem 'sprockets'
gem 'sprockets-es6'

gem 'compass-rails'
gem 'jquery-rails'
gem 'letter_opener', group: :development
gem 'ng-rails-csrf'
gem 'uglifier'

group :development, :test do
  gem 'binding_of_caller'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'pry'
  gem 'pry-nav'
  gem 'rails-controller-testing' # For 'assert_template'
  gem 'rspec-rails'
  gem 'rubocop', '1.8.1', require: false
  gem 'travis', require: false
end

group :test do
  gem 'capybara'
  gem 'capybara-angular'
  gem 'coveralls'
  gem 'database_cleaner'
  gem 'phantomjs'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'smarf_doc'
  gem 'test-unit'
  gem 'vcr'
  gem 'webmock'
end

group :production, :staging do
  gem 'rack-timeout'
  gem 'rails_12factor'
  gem 'thin'
end
