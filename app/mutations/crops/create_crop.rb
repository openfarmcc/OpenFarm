module Crops
  class CreateCrop < Mutations::Command
    attr_reader :pictures
    include PicturesMixin
    include Crops::CropsConcern

    required do
      model :user
      hash :attributes do
        required do
          string :name
        end
        optional do
          array :common_names
          string :binomial_name
          string :description
          string :sun_requirements
          string :sowing_method
          integer :spread
          integer :days_to_maturity
          integer :row_spacing
          integer :height
        end
      end
    end

    optional do
      array :images, class: Hash, arrayize: true
    end

    def validate
      validate_permissions

      validate_images images
    end

    def execute
      @crop = Crop.new(attributes)
      @crop.save
      set_images images, @crop
      @crop.save
      @crop
    end

    private

    def validate_permissions
      # TODO: This should call on the Pundit policy
      true
    end
  end
end
