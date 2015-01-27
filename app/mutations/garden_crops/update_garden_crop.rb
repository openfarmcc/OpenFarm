module GardenCrops
  class UpdateGardenCrop < Mutations::Command
    required do
      model :user
      model :garden_crop
    end

    optional do
      string :quantity
      string :stage
      date :sowed
    end

    def validate
      validate_permissions
    end

    def execute
      set_valid_params
      garden_crop
    end

    def validate_permissions
      if garden_crop.garden.user != user
        msg = 'You can only update crops that are in your gardens.'
        add_error :garden, :not_authorized, msg
      end
    end

    def set_valid_params
      garden_crop.quantity    = quantity if quantity.present?
      garden_crop.stage       = stage if stage.present?
      garden_crop.sowed       = sowed if stage.present?
      garden_crop.save
    end
  end
end
