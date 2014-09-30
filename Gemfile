source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.0.2' # TODO: Upgrade when Mongoid is compatible.

# Foundation
gem 'foundation-rails', '~> 5.2.0'
gem 'sass-rails', '~> 4.0.0'
gem 'font-awesome-sass'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'bcrypt-ruby'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mongoid_slug'
gem 'aws-sdk', '~> 1.3.4'
gem 'mutations'
gem 'rack-attack'
gem 'impressionist'
gem 'mongoid-history'
gem 'rack-cors', require: 'rack/cors'
gem 'delayed_job_mongoid'

group :development, :test do
  gem 'coveralls', require: false
  gem 'rubocop'
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'launchy'
  gem 'quiet_assets' # Turns off the Rails asset pipeline log
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'metric_fu' # Code quality tool.
end

group :test do
  gem 'doc_yo_self'
  gem 'capybara'
  gem 'poltergeist'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
end

group :production, :staging do
  gem 'thin'
  gem 'exception_notification'
  gem 'rails_12factor' # for dokku
end

#Used for static pages in /app/views/pages
gem 'high_voltage'
gem 'devise'
gem 'rails_admin'
gem 'ng-rails-csrf' # TODO: Token auth, or something...
# Some extra gems for signing up through Twitter or Facebook
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Helps Mongo run fast.
gem 'bson_ext'
gem 'mongoid', :github => 'mongoid/mongoid'
gem 'mongoid_search'
gem 'active_model_serializers'