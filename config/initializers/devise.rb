Devise.setup do |config|
  config.mailer_sender = 'team@openfarm.cc'
  require 'devise/orm/mongoid'
  config.case_insensitive_keys = [ :email ]
  config.stretches = Rails.env.test? ? 1 : 10
  config.password_length = 8..128
  config.reset_password_within = 6.hours
end
