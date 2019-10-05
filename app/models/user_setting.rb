class UserSetting
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  belongs_to :user, optional: true
  has_and_belongs_to_many :favorite_crops, class_name: 'Crop', inverse_of: nil

  field :location, type: String
  field :years_experience, type: Integer
  field :units, type: String

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, as: :photographic
  accepts_nested_attributes_for :pictures

  def favorite_crop_image
    favorite_crops.first.main_image_path if favorite_crops.first.present?
  end
end
