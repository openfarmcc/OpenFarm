class Garden
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :user
  validates :user, presence: true

  embeds_many :garden_crops

  field :name
  field :description
  field :is_private, type: Mongoid::Boolean, default: false

  field :location # users can have gardens in different locations
  field :type # outdoor, indoor, hydroponic, etc
  field :average_sun # full, partial, etc
  field :soil_type # clay, high organic, etc
  field :ph # 0-14
  field :growing_practices, type: Array # organic, permaculutre, etc

  scope :is_public, -> { where(is_private: true) }
end
