source "https://rubygems.org"

ruby "2.6.1"

gem "rails"
gem "bundler"

# We can't upgrade to Mongoid 7 unless someone has
# time to manually QA the failed view specs that
# it causes. -RC 15 MAR 19
gem "mongoid", "~> 6"
gem "delayed_job_mongoid" # <= Problematic dep upgrade
gem "delayed_job_shallow_mongoid"
gem "kaminari-mongoid"
gem "mongoid_taggable"
gem "mongoid-history"
gem "mongoid-slug"
gem "mongoid-paperclip", require: "mongoid_paperclip"

gem "active_model_serializers"
gem "aws-sdk-rails"
gem "aws-sdk-s3"
gem "bson_ext"

gem "searchkick"
# This gem requires a manual upgrade.
# Help appreciated -RC 15 MAR 19
gem "gibbon", "~> 1"
gem "jsonapi-serializers"
gem "devise"
gem "eventmachine"
gem "high_voltage"
gem "impressionist"
gem "merit"
gem "mutations"
gem "pundit"
gem "rails_admin"
gem "rack-attack"
gem "rollbar"
gem "sass-rails"
gem "coffee-rails"
gem "utf8-cleaner"
gem "platform-api"
gem "rack-cors", require: "rack/cors"

# Asset management using bower
# https://rails-assets.org/
source "https://rails-assets.org" do
  gem "rails-assets-jquery", "~> 2.1"
  gem "rails-assets-jquery-ui", "~> 1.11"
  gem "rails-assets-angular", "1.5.8"
  gem "rails-assets-angular-sanitize", "1.5.8"
  gem "rails-assets-angular-dragdrop", "~> 1.0"
  gem "rails-assets-angular-foundation", "~> 0.8"
  gem "rails-assets-angular-ui-sortable", "~> 0.13"
  gem "rails-assets-angular-local-storage", "~> 0.2"
  gem "rails-assets-angular-typeahead", "~> 0.3"
  gem "rails-assets-ng-tags-input", "~> 2.0"
  gem "rails-assets-ng-file-upload", "~> 12.2"
  gem "rails-assets-moment", "2.8.4"
  gem "rails-assets-showdown", "~> 0.5"
end

gem "font-awesome-sass"

# WARNING: Upgrading to foundation v6 is _not_ a trivial task.
gem "foundation-rails", "5.5.2.1"
gem "sprockets"
gem "sprockets-es6"

gem "jquery-rails"
gem "ng-rails-csrf"
gem "compass-rails"
gem "uglifier"
gem "letter_opener", group: :development

group :development, :test do
  gem "rspec-rails"
  gem "pry"
  gem "pry-nav"
  gem "launchy"
  gem "factory_bot_rails"
  gem "faker"
  gem "binding_of_caller"
  gem "rails-controller-testing" # For 'assert_template'
end

group :test do
  gem "test-unit"
  gem "smarf_doc"
  gem "capybara"
  gem "capybara-angular"
  gem "phantomjs"
  gem "database_cleaner"
  gem "vcr"
  gem "webmock"
  gem "simplecov"
  gem "coveralls"
  gem "selenium-webdriver"
end

group :production, :staging do
  gem "thin"
  gem "exception_notification"
  gem "rails_12factor"
  gem "rack-timeout"
end

group :production do
  gem "letsencrypt-rails-heroku"
end
