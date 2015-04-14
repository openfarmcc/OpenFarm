class CropSerializer < ApplicationSerializer
  attributes :_id, :name, :binomial_name, :common_names, :description,
             :sun_requirements, :sowing_method, :spread,
             :row_spacing, :height

  has_many :pictures, serializer: PictureSerializer
end
