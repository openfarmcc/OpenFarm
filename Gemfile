source "https://rubygems.org"

ruby "2.6.0"

gem "rails", "~> 5"
gem "bundler", "~> 1.17"

gem "mongoid"
gem "delayed_job_mongoid"
gem "delayed_job_shallow_mongoid"
gem "kaminari-mongoid"
gem "mongoid_taggable"
gem "mongoid-history"
gem "mongoid-slug"
gem "mongoid-paperclip", require: "mongoid_paperclip"

gem "active_model_serializers", "~> 0"
gem "aws-sdk-rails", "~> 2"
gem "aws-sdk", "~> 3"
gem "bson_ext", "~> 1"

gem "searchkick", "~> 3.1.2"
gem "gibbon", "~> 1"
gem "jsonapi-serializers", "~> 0"
gem "devise", "~> 4"
gem "eventmachine", "~> 1"
gem "high_voltage", "~> 3"
gem "impressionist", "~> 1"
gem "merit", "~> 3"
gem "mutations", "~> 0"
gem "pundit", "~> 2"
gem "rails_admin", "~> 1"
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

gem "foundation-rails", "~> 6.5"
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"

gem "jquery-rails"
gem "ng-rails-csrf"
gem "compass-rails"
gem "uglifier", ">= 1"
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
  gem "poltergeist"
  gem "phantomjs", ">= 1.8"
  gem "database_cleaner", "~> 1.3"
  gem "vcr"
  gem "webmock"
end

group :production, :staging do
  gem "thin"
  gem "exception_notification", "~> 4.2"
  gem "rails_12factor"
  gem "rack-timeout"
end

group :production do
  gem "letsencrypt-rails-heroku"
end
