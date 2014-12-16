module Crops
  class UpdateCrop < Mutations::Command
    attr_reader :pictures

    include Crops::CropsConcern

    required do
      string :id
      model :user
      model :crop
    end

    optional do
      string :name
      array :common_names
      string :binomial_name
      string :description
      string :sun_requirements
      string :sowing_method
      integer :spread
      integer :days_to_maturity
      integer :row_spacing
      integer :height
      array :images, class: String, arrayize: true
    end

    def validate
      validate_permissions
      validate_images
    end

    def execute
      set_pictures
      set_valid_params
      crop
    end

    private

    def validate_permissions
      # TODO: This should call on the Pundit policy
      true
    end

    def set_valid_params
      # TODO: Probably a DRYer way of doing this.
      crop.name           = name if name.present?
      crop.binomial_name  = binomial_name if binomial_name.present?
      crop.description    = description if description.present?
      crop.common_names   = common_names if common_names.present?
      crop.binomial_name  = binomial_name if binomial_name.present?
      crop.sun_requirements = sun_requirements if sun_requirements.present?
      crop.sowing_method  = sowing_method if sowing_method.present?
      crop.spread         = spread if spread.present?
      crop.days_to_maturity = days_to_maturity if days_to_maturity.present?
      crop.row_spacing    = row_spacing if row_spacing.present?
      crop.height         = height if height.present?
      crop.save
    end
  end
end
