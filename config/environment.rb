if File.exists?('config/app_environment_variables.rb')
  load 'config/app_environment_variables.rb'
else
  warning = [
    'You might still need to set your ENV variables inside of'
    'config/app_environment_variables.rb Take a look at'
    'config/app_environment_variables.rb.example. Raise an issue on'
    'OpenFarms GitHub page if you still cant get it working. If you'
    'are seeing this from within your CI or production server, you can'
    'ignore this message. Make sure you set your ENV vars, though.'
  ].join(' ')
  warn warning
end

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
OpenFarm::Application.initialize!
