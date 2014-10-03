class CropSerializer < ApplicationSerializer
  attributes :_id, :name, :binomial_name, :description, :sun_requirements,
             :sowing_method, :spread, :days_to_maturity, :row_spacing, :height
end
