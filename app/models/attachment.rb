# Generic File attachment class.
class Attachment
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :file
  validates_attachment_size :file, in: 1.byte..2.megabytes
  validates_attachment :file,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
end
