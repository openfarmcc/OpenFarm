class Image
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :crop

  has_mongoid_attached_file :attachment

  validates_attachment :attachment,
    :content_type => {:content_type => ["image/jpeg", "image/gif", "image/png"]}

end
