class Attachment
  include Mongoid::Document
  ACCEPTED_CONTENT_TYPES = ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  belongs_to :guide

  # SOON.
  # has_attached_file :file,
  #   storage: :s3,
  #   s3_credentials: {
  #     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  #     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  #   },
  #   s3_bucket: ENV['S3_BUCKET_NAME'],
  #   path: ":class/:id/:basename_:style.:extension"

  # validates_attachment :file,
                         # content_type: {content_type: ACCEPTED_CONTENT_TYPES}
end
