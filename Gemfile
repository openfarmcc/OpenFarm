source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'rails_12factor' # for dokku

# assets
gem 'rails-assets-jquery'
gem 'rails-assets-foundation'
gem 'jquery-rails'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder'

gem 'bcrypt-ruby'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
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

#Used for static pages in /app/views/pages
gem 'high_voltage'

gem 'devise'

# Some extra gems for signing up through Twitter or Facebook
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Helps Mongo run fast.
gem 'bson_ext'
gem 'mongoid', :github => 'mongoid/mongoid'
gem 'mongoid_search'
