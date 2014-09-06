if File.exists?('config/app_environment_variables.rb')
  load 'config/app_environment_variables.rb'
end

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
OpenFarm::Application.initialize!
