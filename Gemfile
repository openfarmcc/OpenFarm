source 'https://rubygems.org'

ruby '2.3.3'

gem 'bundler', '>= 1.7.0'

gem 'rails', '~> 4.2.0'

# Foundation
gem 'foundation-rails', '~> 5.4.5'
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
gem 'aws-sdk'
gem 'aws-sdk-rails'
gem 'mutations'
gem 'rack-attack'
gem 'impressionist'
gem 'rack-cors', require: 'rack/cors'
gem 'delayed_job_mongoid'
gem 'delayed_job_shallow_mongoid'
gem 'activejob_backport'
gem 'patron' # For searchKick
gem 'elasticsearch', '~> 2' # The project doesn't use semver, so this should only be upgraded on the jump to elasticsearch 5
gem 'searchkick', '~> 1.5.1' # Have to evaluate the breaking changes in https://github.com/ankane/searchkick/blob/master/CHANGELOG.md
gem 'pundit'
gem 'eventmachine'
gem 'merit'
gem 'gibbon', '~> 1.1.5'
gem 'jsonapi-serializers', '~> 0.2.4'
gem 'mongoid-history'
gem 'mongoid_taggable'

gem 'utf8-cleaner'

gem 'bson_ext'
gem 'mongoid', '~>4.0.2'
gem 'active_model_serializers'

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

#Used for static pages in /app/views/pages
gem 'high_voltage'
gem 'devise', '~> 4.2.0'
gem 'rails_admin'
gem 'ng-rails-csrf'

# LETSENCRYPT
# Until the new API calls are generally available, you must manually specify my fork
# of the Heroku API gem:
gem 'platform-api', github: 'jalada/platform-api', branch: 'master'

gem 'letsencrypt-rails-heroku', group: 'production'
