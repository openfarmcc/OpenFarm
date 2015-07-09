module GardenCrops
  class CreateGardenCrop < Mutations::Command
    # attr_writer :garden_crop

    required do
      model :user
      string :garden_id
      hash :attributes do
        optional do
          string :quantity
          string :guide
          string :crop
          string :stage
          date :sowed
        end
      end
    end

    def validate
      validate_guide
      validate_crop
      validate_garden
      validate_permissions
    end

    def execute
      @garden_crop ||= GardenCrop.new(attributes)
      # if @guide
      #   @garden_crop.guide = @guide
      # end
      # if @crop
      #   @garden_crop.crop = @crop
      # end
      @garden_crop.garden = @garden
      @garden_crop.save
      # puts @garden_crop.to_json
      @garden_crop
    end

    def validate_guide
      if attributes[:guide]
        attributes[:guide] = Guide.find(attributes[:guide])
      end
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide, :guide_not_found, msg
    end

    def validate_crop
      if attributes[:crop]
        attributes[:crop] = Crop.find(attributes[:crop])
      end
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a crop with id #{crop_id}."
      add_error :crop, :crop_not_found, msg
    end

    def validate_garden
      @garden = Garden.find(garden_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a garden with id #{garden_id}."
      add_error :garden, :garden_not_found, msg
    end

    def validate_permissions
      if @garden && (@garden.user != user)
        msg = 'You can\'t create garden crops for gardens you don\'t own.'
        add_error :garden, :not_authorized, msg
      end
    end
  end
end
