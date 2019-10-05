# frozen_string_literal: true

rollbar_token = ENV['ROLLBAR_ACCESS_TOKEN']

Rollbar.configure do |config|
  if rollbar_token
    config.enabled = true
    config.access_token = rollbar_token
    config.person_method = 'current_user'
    config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
  else
    config.enabled = false
  end
end
