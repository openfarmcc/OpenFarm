module Crops
  class UpdateCrop < Mutations::Command
    attr_reader :pictures
    include PicturesMixin
    include Crops::CropsConcern

    required do
      string :id
      model :user
      hash :attributes do
        optional do
          string :name
          array :common_names
          string :binomial_name
          string :taxon
          string :svg_icon
          string :description
          string :sun_requirements
          string :sowing_method
          integer :spread
          integer :days_to_maturity
          integer :row_spacing
          integer :height
          integer :growing_degree_days
          array :tags_array
        end
      end
    end

    optional do
      array :images, class: Hash, arrayize: true
    end

    def validate
      validate_permissions
      @crop = Crop.find(id)
      validate_images images, @crop
    end

    def execute
      set_images images, @crop
      @crop.update_attributes(attributes)
      @crop
    end

    private

    def validate_permissions
      # TODO: This should call on the Pundit policy
      true
    end
  end
end
