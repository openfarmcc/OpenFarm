options = { storage: :s3,
            path: '/:rails_env/media/:class/:attachment/:id.:extension',
            s3_credentials: { bucket: ENV['S3_BUCKET_NAME'],
                              access_key_id: ENV['SERVER_S3_ACCESS_KEY'],
                              secret_access_key: ENV['SERVER_S3_SECRET_KEY']} }
Paperclip::Attachment.default_options.merge!(options)
