module GardenCrops
  class UpdateGardenCrop < Mutations::Command
    required do
      model :user
      model :garden_crop
      hash :attributes do
        optional do
          string :quantity
          string :stage
          date :sowed
        end
      end
    end

    def validate
      validate_permissions
    end

    def execute
      garden_crop.update_attributes(attributes)
      garden_crop
    end

    def validate_permissions
      if garden_crop.garden.user != user
        msg = 'You can only update crops that are in your gardens.'
        add_error :garden, :not_authorized, msg
      end
    end
  end
end
