options = { storage: :s3,
            path: '/:rails_env/media/:class/:attachment/:id.:extension',
            s3_credentials: { bucket: ENV['S3_BUCKET_NAME'],
                              access_key_id: ENV['S3_ACCESS_KEY'],
                              secret_access_key: ENV['S3_SECRET_KEY']} }
Paperclip::Attachment.default_options.merge!(options)
