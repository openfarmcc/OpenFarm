source 'https://rubygems.org'

ruby '2.2.0'

gem 'bundler', '>= 1.7.0'

gem 'rails', '~> 4.1.9' # TODO: Upgrade when Mongoid is compatible.

# Foundation
gem 'foundation-rails', '~> 5.5.0'
gem 'sass-rails', '~> 4.0.4'
gem 'compass-rails', '~> 2.0.0'
gem 'font-awesome-sass'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'bcrypt'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mongoid-slug'
gem 'aws-sdk', '~> 1.55'
gem 'mutations'
gem 'rack-attack'
gem 'impressionist'
gem 'rack-cors', require: 'rack/cors'
gem 'delayed_job_mongoid'
gem 'delayed_job_shallow_mongoid'
gem 'activejob_backport'
gem 'patron' # For searchKick
gem 'searchkick'
gem 'pundit'
gem 'eventmachine'
gem 'merit'
gem 'gibbon', '~> 1.1.5'
gem 'jsonapi-serializers', '~> 0.2.4'
gem 'mongoid-history'

gem 'utf8-cleaner'

gem 'bson_ext'
gem 'mongoid', '~>4.0.2'
gem 'active_model_serializers'

# https://github.com/heroku/rack-timeout
gem 'rack-timeout'

# Asset management using bower
# https://rails-assets.org/
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '~> 2.2.1'
  gem 'rails-assets-jquery-ui', '~> 1.11.4'
  gem 'rails-assets-angular', '~> 1.5.0'
  gem 'rails-assets-angular-dragdrop', '~> 1.0.13'
  gem 'rails-assets-angular-foundation', '~> 0.8.0'
  gem 'rails-assets-angular-ui-sortable', '~> 0.13.4'
  gem 'rails-assets-angular-local-storage', '~> 0.2.3'
  gem 'rails-assets-angular-typeahead', '~> 0.3.1'
end

group :development, :test do
  gem 'coveralls', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'test-unit'
  gem 'smarf_doc'
  gem 'capybara'
  gem 'capybara-angular'
  gem 'poltergeist'
  gem 'phantomjs', '>= 1.8.1', :require => 'phantomjs/poltergeist'
  gem 'simplecov'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'rubocop'
  gem "letter_opener"
end

group :production, :staging do
  gem 'thin'
  gem 'exception_notification'
  gem 'rails_12factor'
end

#Used for static pages in /app/views/pages
gem 'high_voltage'
gem 'devise', '~> 4.2.0'
gem 'rails_admin'
gem 'ng-rails-csrf'
