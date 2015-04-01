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
  config.after_initialize do
    Crop.reindex
    Guide.reindex
  end

  options = { storage: :s3,
              s3_protocol: :https,
              path: '/:rails_env/media/:class/:attachment/:id.:extension',
              s3_credentials: { bucket: ENV['S3_BUCKET_NAME'],
                                s3_protocol: :https,
                                access_key_id: ENV['SERVER_S3_ACCESS_KEY'],
                                secret_access_key: ENV['SERVER_S3_SECRET_KEY'] } }

  Paperclip::Attachment.default_options.merge!(options)
end
