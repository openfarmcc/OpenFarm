rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes 4

working_directory "/home/deploy/repository" # available in 0.94.0+

listen "/home/deploy/shared/pids/openfarm.sock", :backlog => 64
listen 8080, :tcp_nopush => true

timeout 600

pid "/home/deploy/shared/pids/unicorn.pid"

stderr_path "/home/deploy/shared/log/unicorn.stderr.log"
stdout_path "/home/deploy/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
