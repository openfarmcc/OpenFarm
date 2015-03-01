source 'https://rubygems.org'

ruby '2.2.0'

gem 'bundler', '>= 1.7.0'

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
gem 'rack-cors', require: 'rack/cors'
gem 'delayed_job_mongoid'
gem 'activejob_backport'
gem 'patron' # For searchKick
gem 'searchkick', '~> 0.8.5'
gem 'pundit'
gem 'eventmachine', '~> 1.0.4' # Temp fix for failing Linux builds.

# Asset management using bower
# https://rails-assets.org/
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-dragdrop'
  gem 'rails-assets-angular-foundation'
  gem 'rails-assets-angular-ui-sortable'
end

group :development, :test do
  gem 'coveralls', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'pry'
  gem 'pry-nav'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'test-unit'
  gem 'doc_yo_self'
  gem 'capybara'
  gem 'poltergeist'
  gem 'phantomjs', '>= 1.8.1', :require => 'phantomjs/poltergeist'
  gem 'simplecov'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'rubocop'
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
gem 'mongoid', :github => 'mongoid/mongoid', tag: 'v4.0.1'
gem 'active_model_serializers'
