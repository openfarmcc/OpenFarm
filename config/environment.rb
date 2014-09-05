load 'config/app_environment_variables.rb' if File.exists?('config/app_environment_variables.rb')

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
OpenFarm::Application.initialize!
