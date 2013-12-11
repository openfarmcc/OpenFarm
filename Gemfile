source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'git-deploy'
end

group :development, :test do
  gem 'rspec-rails'
  # A really really great alternative to the debugger
  gem 'pry'
  gem 'pry-nav'
  # Need this to use `save_and_open_page` when debugging / testing.
  gem 'launchy'
end

group :test do
  gem 'factory_girl_rails'
  #TODO: Upgrade capybara / poltergeist
  gem 'capybara'
  gem 'poltergeist'
  gem 'simplecov'
  gem 'database_cleaner'
end

gem 'high_voltage'
# Helps Mongo run fast.
gem 'bson_ext'
gem 'mongoid', :github => 'mongoid/mongoid'
gem 'mongoid_search'
