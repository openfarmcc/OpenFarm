class CropSerializer < BaseSerializer
  attribute :name
  attribute :binomial_name
  attribute :common_names
  attribute :description
  attribute :sun_requirements
  attribute :sowing_method
  attribute :spread
  attribute :row_spacing
  attribute :height

  has_many :pictures, serializer: PictureSerializer
end
