# frozen_string_literal: true

class GardenSerializer < BaseSerializer
  attribute :name
  attribute :description
  attribute :location
  attribute :type
  attribute :average_sun
  attribute :soil_type
  attribute :ph
  attribute :growing_practices
  attribute :is_private
  attribute :user
  # inserting the 'has_one :user' means that a user gets inserted,
  # which has as result that this garden gets inserted, recursive etc.
  # 'stack level too deep', so. Maybe we need a 'ShortUserSerializer'? ToDo
  # has_one :user

  has_many :garden_crops
  has_many :pictures, serializer: PictureSerializer
end
