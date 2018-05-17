source 'https://rubygems.org'

ruby '2.3.3'

gem 'active_model_serializers'
gem 'activejob_backport'
gem 'aws-sdk-rails'
gem 'aws-sdk'
gem 'bcrypt'
gem 'bson_ext'
gem 'bundler', '>= 1.7.0'
gem 'coffee-rails'
gem 'compass-rails', '>= 2.0.2'
gem 'delayed_job_mongoid'
gem 'delayed_job_shallow_mongoid'
gem 'devise'
# The project doesn't use semver, so this should only be upgraded on the jump
# to elasticsearch 5
gem 'elasticsearch', '~> 2'
gem 'eventmachine'
gem 'font-awesome-sass'
gem 'foundation-rails'
gem 'gibbon', '~> 1.1.5'
gem 'high_voltage' # Used for static pages in /app/views/pages
gem 'impressionist'
gem 'jquery-rails'
gem 'jsonapi-serializers', '~> 0.2.4'
gem 'kaminari-mongoid'
gem 'letsencrypt-rails-heroku', group: 'production'
gem 'merit'
gem 'mongoid_taggable'
gem 'mongoid-history'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mongoid-slug'
gem 'mongoid', '~>4.0.2'
gem 'mutations'
gem 'ng-rails-csrf'
gem 'patron' # For searchKick
gem 'platform-api' # LETSENCRYPT
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'rails_admin'
gem 'rails'
gem 'rollbar'
gem 'sass-rails'
# Have to evaluate the breaking changes
# in https://github.com/ankane/searchkick/blob/master/CHANGELOG.md
gem 'searchkick', '~> 1.5.1'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'
gem 'utf8-cleaner'

# Asset management using bower
# https://rails-assets.org/
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '~> 2.2.1'
  gem 'rails-assets-jquery-ui', '~> 1.11.4'
  gem 'rails-assets-angular', '~> 1.5.0'
  gem 'rails-assets-angular-sanitize', '~> 1.5.0'
  gem 'rails-assets-angular-dragdrop', '~> 1.0.13'
  gem 'rails-assets-angular-foundation', '~> 0.8.0'
  gem 'rails-assets-angular-ui-sortable', '~> 0.13.4'
  gem 'rails-assets-angular-local-storage', '~> 0.2.3'
  gem 'rails-assets-angular-typeahead', '~> 0.3.1'
  gem 'rails-assets-ng-tags-input', '~>2.3.0'
  gem 'rails-assets-ng-file-upload', '~>12.2.13'
  gem 'rails-assets-moment', '~>2.8.3'
  gem 'rails-assets-showdown', '~>0.5.4'
end

group :development, :test do
  gem 'coveralls', '>= 0.8.11', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'binding_of_caller'
end

group :test do
  gem 'test-unit'
  gem 'smarf_doc'
  gem 'capybara'
  gem 'capybara-angular'
  gem 'poltergeist'
  gem 'phantomjs', '>= 1.8.1', :require => 'phantomjs/poltergeist'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'rubocop', '~> 0.49.0'
  gem 'rainbow', '~> 2.1.0' # https://github.com/sickill/rainbow/issues/48
  gem "letter_opener"
end

group :production, :staging do
  gem 'thin'
  gem 'exception_notification'
  gem 'rails_12factor'
  # https://github.com/heroku/rack-timeout
  gem 'rack-timeout'
end
