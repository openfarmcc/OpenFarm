class CropSerializer < BaseSerializer
  attribute :name
  attribute :slug
  attribute :binomial_name
  attribute :common_names
  attribute :description
  attribute :sun_requirements
  attribute :sowing_method
  attribute :spread
  attribute :row_spacing
  attribute :height
  attribute :processing_pictures
  attribute :guides_count
  attribute :main_image_path
  attribute :taxon
  attribute :tags_array
  attribute :growing_degree_days

  has_many :pictures, serializer: PictureSerializer
end
