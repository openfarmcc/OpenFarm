module Gardens
  class UpdateGarden < Mutations::Command
    required do
      model :user
      model :garden
    end

    optional do
      string :name
      string :location
      string :description
      string :type
      string :average_sun
      string :soil_type
      integer :ph
      Array :growing_practices
    end

    def validate
      validate_permissions
    end

    def execute
      set_valid_params
      garden
    end

    def validate_permissions
      if garden.user != user
        msg = 'You can only update gardens that belong to you.'
        add_error :garden, :not_authorized, msg
      end
    end

    def set_valid_params
      garden.user           = user
      garden.name           = name if name.present?
      garden.location       = location if location.present?
      garden.description    = description if description.present?
      garden.type           = type if type.present?
      garden.average_sun    = average_sun if average_sun.present?
      garden.soil_type      = soil_type if soil_type.present?
      garden.ph             = ph if ph.present?
      # TODO: growing practices
      garden.save
    end
  end
end
