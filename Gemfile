source 'https://rubygems.org'

ruby '2.1.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'rails_12factor' # for dokku

# Foundation
gem 'foundation-rails', '~> 5.2.0'
# gem 'zurb-foundation', '4.3.2'

#jQuery UI
gem 'jquery-ui-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# font awesome
gem 'font-awesome-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

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
  gem 'quiet_assets' # Turns off the Rails asset pipeline log
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
