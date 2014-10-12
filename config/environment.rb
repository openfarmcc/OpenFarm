if File.exists?('config/app_environment_variables.rb')
  load 'config/app_environment_variables.rb'
else
  warning = 'You still need to set your ENV variables inside of'\
            ' config/app_environment_variables.rb Take a look at '\
            'config/app_environment_variables.rb.example. Raise an issue on'\
            'GitHub if you still cant get it working.'
  warn warning
end

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
OpenFarm::Application.initialize!
