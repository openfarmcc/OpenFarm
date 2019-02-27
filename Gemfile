source "https://rubygems.org"

ruby "2.6.0"

gem "rails"
gem "bundler"

gem "mongoid"
gem "delayed_job_mongoid"
gem "delayed_job_shallow_mongoid"
gem "kaminari-mongoid"
gem "mongoid_taggable"
gem "mongoid-history"
gem "mongoid-slug"
gem "mongoid-paperclip", require: "mongoid_paperclip"

gem "active_model_serializers"
gem "aws-sdk-rails"
gem "aws-sdk"
gem "bson_ext"

gem "searchkick"
gem "gibbon"
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
  gem "rails-assets-moment", "~> 2.3"
  gem "rails-assets-showdown", "~> 0.5"
end

gem "font-awesome-sass"

gem "foundation-rails"
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
  gem "puma" # For capybara
end

group :test do
  gem "test-unit"
  gem "smarf_doc"
  gem "capybara"
  gem "capybara-angular"
  gem "apparition"
  gem "phantomjs"
  gem "database_cleaner"
  gem "vcr"
  gem "webmock"
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
