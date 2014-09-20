options = { storage: :s3,
            path: '/:rails_env/media/:class/:attachment/:id.:extension',
            s3_credentials: { bucket: ENV['MASTER_BUCKET_NAME'],
                              access_key_id: ENV['MASTER_ACCESS_KEY'],
                              secret_access_key: ENV['MASTER_SECRET_KEY']} }
Paperclip::Attachment.default_options.merge!(options)
