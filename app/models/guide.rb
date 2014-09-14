class Guide
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Paperclip

  belongs_to :crop
  belongs_to :user
  has_many :stages
  has_many :requirements

  field :name
  field :overview
  validates_presence_of :user, :crop, :name

  has_mongoid_attached_file :featured_image, default_url: '/img/empty-pot.png'
  validates_attachment_size :featured_image, in: 1.byte..2.megabytes
  validates_attachment :featured_image,
                       content_type: { content_type:
                         ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  def owned_by?(user)
    user && (self.user == user)
  end
end
