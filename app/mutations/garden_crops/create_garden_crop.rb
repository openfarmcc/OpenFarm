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
      validate_guide_or_crop
      validate_garden
      validate_permissions
    end

    def execute
      @garden_crop ||= GardenCrop.new(attributes)
      @garden_crop.garden = @garden
      @garden_crop.save
      @garden_crop
    end

    def validate_guide_or_crop
      unless attributes[:guide] || attributes[:crop]
        msg = 'You need either a guide or a crop for the garden crop.'
        add_error :attributes, :not_found, msg
      end
    end

    def validate_guide
      attributes[:guide] = Guide.find(attributes[:guide]) if attributes[:guide]
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{attributes[:guide]}."
      add_error :guide, :guide_not_found, msg
    end

    def validate_crop
      attributes[:crop] = Crop.find(attributes[:crop]) if attributes[:crop]
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a crop with id #{attributes[:crop]}."
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
        msg = "You can't create garden crops for gardens you don't own."
        add_error :garden, :not_authorized, msg
      end
    end
  end
end
