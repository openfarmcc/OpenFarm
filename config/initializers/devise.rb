Devise.setup do |config|
  # Devise is really peculiar about how it is given its SECRET_KEY_BASE
  # TODO: Fix this mess.
  # :nocov:
  if ['production', 'staging'].include?(Rails.env)
    devise_acts_weird = ENV['SECRET_KEY_BASE']
  else
    devise_acts_weird = ENV['SECRET_KEY_BASE']  || `rake secret`
  end
  # :nocov:
  config.secret_key = devise_acts_weird
  config.mailer_sender = 'team@openfarm.cc'
  require 'devise/orm/mongoid'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage  = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
