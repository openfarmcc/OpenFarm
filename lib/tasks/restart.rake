# frozen_string_literal: true

namespace :utils do
  desc 'restart unicorn'
  task restart_server: :environment do
    system 'rake assets:precompile RAILS_ENV=production'
    system '/etc/init.d/unicorn restart'
  end
end
