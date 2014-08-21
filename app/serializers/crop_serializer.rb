class CropSerializer < ApplicationSerializer
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false

  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = false
  attributes :name, :binomial_name, :description, :sun_requirements,
             :sowing_method, :spread, :days_to_maturity, :row_spacing, :height
end