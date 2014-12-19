source 'https://rubygems.org'

ruby '2.1.3'

gem 'rails', '4.0.2' # TODO: Upgrade when Mongoid is compatible.

# Foundation
gem 'foundation-rails', '~> 5.4.5'
gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'font-awesome-sass'
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
gem 'mongoid-history'
gem 'rack-cors', require: 'rack/cors'
gem 'delayed_job_mongoid'
gem 'patron' # For searchKick
gem 'searchkick', '~> 0.8.5'
gem "pundit"

group :development, :test do
  gem 'coveralls', require: false
  gem 'quiet_assets'
  gem 'rubocop'
  gem 'better_errors'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'pry'
  gem 'pry-nav'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'doc_yo_self'
  gem 'capybara'
  gem 'poltergeist'
  gem 'phantomjs', '>= 1.8.1', :require => 'phantomjs/poltergeist'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
end

group :production, :staging do
  gem 'thin'
  gem 'exception_notification'
  gem 'rails_12factor'
end

#Used for static pages in /app/views/pages
gem 'high_voltage'
gem 'devise'
gem 'rails_admin'
gem 'ng-rails-csrf'

gem 'bson_ext'
gem 'mongoid', :github => 'mongoid/mongoid'
gem 'active_model_serializers'
