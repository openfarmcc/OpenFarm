Crop.reindex
Guide.reindex

OpenFarm::Application.configure do
  Delayed::Worker.delay_jobs = false
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.quiet_assets = true
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
end
