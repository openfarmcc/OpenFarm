source 'https://rubygems.org'

ruby '2.5.1'

gem 'rails',   '~> 5'
gem 'bundler', '~> 1.17'

gem 'mongoid'
gem 'delayed_job_mongoid'
gem 'delayed_job_shallow_mongoid'
gem 'kaminari-mongoid'
gem 'mongoid_taggable'
gem 'mongoid-history'
gem 'mongoid-slug'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'#, '~> 0.0'

gem 'active_model_serializers', '~> 0'
gem 'aws-sdk-rails',            '~> 2'
gem 'aws-sdk',                  '~> 3'
gem 'bson_ext',                 '~> 1'

# The project doesn't use semver, so this should only be upgraded on the jump
# to elasticsearch 5
gem 'elasticsearch',       '~> 6'
gem 'gibbon',              '~> 1'
gem 'jsonapi-serializers', '~> 0'
gem 'devise',              '~> 4'
gem 'eventmachine',        '~> 1'
gem 'high_voltage',        '~> 3'
gem 'impressionist',       '~> 1'
gem 'merit',               '~> 3'
gem 'mutations',           '~> 0'
gem 'pundit',              '~> 2'
gem 'rack-attack'#,         '~> 0.0'
gem 'rails_admin',          '~> 1'
gem 'rollbar'#,             '~> 0.0'
gem 'sass-rails'#,          '~> 0.0'
gem 'coffee-rails'#,        '~> 0.0'
gem 'searchkick',          '~> 1'
gem 'utf8-cleaner'#,        '~> 0.0'
gem 'platform-api'#,        '~> 0.0' # LETSENCRYPT
gem 'rack-cors', require: 'rack/cors'

# Asset management using bower
# https://rails-assets.org/
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery',                '~> 2.1'
  gem 'rails-assets-jquery-ui',             '~> 1.11'
  gem 'rails-assets-angular',               '~> 1.5'
  gem 'rails-assets-angular-sanitize',      '~> 1.5'
  gem 'rails-assets-angular-dragdrop',      '~> 1.0'
  gem 'rails-assets-angular-foundation',    '~> 0.8'
  gem 'rails-assets-angular-ui-sortable',   '~> 0.13'
  gem 'rails-assets-angular-local-storage', '~> 0.2'
  gem 'rails-assets-angular-typeahead',     '~> 0.3'
  gem 'rails-assets-ng-tags-input',         '~> 2.0'
  gem 'rails-assets-ng-file-upload',        '~> 12.2'
  gem 'rails-assets-moment',                '~> 2.3'
  gem 'rails-assets-showdown',              '~> 0.5'
end

gem 'therubyracer', platforms: :ruby
gem 'font-awesome-sass'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'ng-rails-csrf'
gem 'compass-rails'
gem 'uglifier',            '>= 1'

group :development, :test do
  gem 'rspec-rails'#,         '~> 3'
  gem 'pry'#,                '~> 0.0'
  gem 'pry-nav'#,            '~> 0.0'
  gem 'launchy'#,            '~> 0.0'
  gem 'factory_girl_rails'#, '~> 0.0'
  gem 'faker'#,              '~> 0.0'
  gem 'binding_of_caller'#,  '~> 0.0'
end

group :test do
  gem 'test-unit'#,        '~> 0.0'
  gem 'smarf_doc'#,        '~> 0.0'
  gem 'capybara'#,         '~> 0.0'
  gem 'capybara-angular'#, '~> 0.0'
  gem 'poltergeist'#,      '~> 0.0'
  gem 'phantomjs',        '>= 1.8', require: 'phantomjs/poltergeist'
  gem 'database_cleaner', '~> 1.3'
  gem 'vcr'#,              '~> 0.0'
  gem 'webmock'#,          '~> 0.0'
end

group :production, :staging do
  gem 'thin'#,                   '~> 0.0'
  gem 'exception_notification',  '~> 4.2'
  gem 'rails_12factor'#,         '~> 0.0'
  gem 'rack-timeout'#,           '~> 0.0'
end

group :production do
  gem 'letsencrypt-rails-heroku'#, '~> 0.0'
end
