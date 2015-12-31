source 'https://rubygems.org'

ruby '2.2.0'

gem 'bundler', '>= 1.7.0'

gem 'rails', '4.1.9' # TODO: Upgrade when Mongoid is compatible.

# Foundation
gem 'foundation-rails', '~> 5.4.5'
gem 'sass-rails', '~> 5.0.4'
gem 'compass-rails'
gem 'font-awesome-sass', '~> 4.5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'bcrypt'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mongoid_slug'
gem 'aws-sdk', '~> 1.55.0'
gem 'mutations'
gem 'rack-attack'
gem 'impressionist', '~> 1.5.0'
gem 'rack-cors', require: 'rack/cors'
gem 'delayed_job_shallow_mongoid'
gem 'delayed_job_mongoid', '~> 2.2.0'
gem 'activejob_backport'
gem 'patron', '~> 0.5.0' # For searchKick
gem 'searchkick', '~> 0.8.7'
gem 'pundit', '~> 1.0.1'
gem 'eventmachine', '~> 1.0.4' # Temp fix for failing Linux builds.
gem 'merit', '~> 2.3.2'
gem 'gibbon', '~> 1.2.0'
gem 'jsonapi-serializers', '~> 0.3.1'

gem 'bson_ext'
gem 'mongoid', '~>4.0.2'
# gem 'mongoid', :github => 'mongoid/mongoid', tag: 'v4.0.2'
gem 'active_model_serializers'

# Asset management using bower
# https://rails-assets.org/
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery-ui', '~> 1.11.4'
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-dragdrop'
  gem 'rails-assets-angular-foundation', '~> 0.6.0'
  gem 'rails-assets-angular-ui-sortable'
  gem 'rails-assets-angular-local-storage'
  gem 'rails-assets-angular-typeahead'
end

group :development, :test do
  gem 'coveralls', '~> 0.8.10', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'pry'
  gem 'pry-nav'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker', '~> 1.6.1'
end

group :test do
  gem 'test-unit'
  gem 'doc_yo_self'
  gem 'capybara', '~> 2.5.0'
  gem 'capybara-angular'
  gem 'poltergeist', '~> 1.8.1'
  gem 'phantomjs', '>= 1.8.1', :require => 'phantomjs/poltergeist'
  gem 'simplecov', '~> 0.11.1'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'rubocop', '~> 0.35.1'
end

group :production, :staging do
  gem 'thin'
  gem 'exception_notification'
  gem 'rails_12factor'
end

#Used for static pages in /app/views/pages
gem 'high_voltage', '~> 2.4.0'
gem 'devise', '~> 3.5.3'
gem 'rails_admin', '~> 0.8.1'
gem 'ng-rails-csrf'
