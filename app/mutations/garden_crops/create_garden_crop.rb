module GardenCrops
  class CreateGardenCrop < Mutations::Command
    required do
      model :user
      string :garden_id
    end

    optional do
      string :quantity
      string :guide_id
      string :stage
      string :sowed
    end

    def garden_crop
      @garden_crop ||= GardenCrop.new
      puts "name" + @guide.name.to_s
      @garden_crop
    end

    def validate
      validate_guide
      validate_garden
      validate_permissions
    end

    def execute
      set_params
      garden_crop
    end

    def validate_guide
      @guide = Guide.find(guide_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide, :guide_not_found, msg
    end

    def validate_garden
      @garden = Garden.find(garden_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a garden with id #{garden_id}."
      add_error :guide, :garden_not_found, msg
    end

    def validate_permissions
      if @garden && (@garden.user != user)
        msg = 'You can\'t create garden crops for gardens you don\'t own.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
      
    end

    def set_params
      garden_crop.garden      = @garden
      garden_crop.guide       = @guide if @guide.present?
      garden_crop.quantity    = quantity if quantity.present?
      garden_crop.stage       = stage if stage.present?
      garden_crop.sowed       = sowed if stage.present?
      garden_crop.save
    end
  end
end
