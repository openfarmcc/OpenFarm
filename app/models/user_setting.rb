class UserSetting
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :user

  field :location, type: String
  field :years_experience, type: Integer
  field :units, type: String

  has_and_belongs_to_many :favorite_crops, class_name: 'Crop', inverse_of: nil

  embeds_one :picture, as: :photographic
  accepts_nested_attributes_for :picture
end
