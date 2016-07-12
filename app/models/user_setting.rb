class UserSetting
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :user

  field :location, type: String
  field :years_experience, type: Integer
  field :units, type: String

  has_and_belongs_to_many :favorite_crops, class_name: 'Crop', inverse_of: nil

  field :processing_pictures, type: Integer, default: 0
  embeds_one :picture, as: :photographic
  accepts_nested_attributes_for :picture

  def get_favorite_crop_image
    favorite_crops.first.main_image_path
  end

  class << self
    def from_url(url, parent)
      parent.picture = Picture.new(
        attachment: open(url)
      )
    end

    handle_asynchronously :from_url
  end
end
