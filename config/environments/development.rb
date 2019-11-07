OpenFarm::Application.configure do
  Delayed::Worker.delay_jobs = false
  # This would be fixed in rails 5 or maybe even 4.2?
  # http://stackoverflow.com/a/25428800/154392
  config.action_dispatch.perform_deep_munge = false
  config.cache_classes = false
  config.log_level = :warn
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.quiet_assets = true
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.after_initialize do
    Crop.reindex
    Guide.reindex
  end
end
