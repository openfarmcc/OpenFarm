module Gardens
  class CreateGarden < Mutations::Command
    required do
      model :user
      string :name
      string :location
      string :type
      string :average_sun
      string :soil_type
      integer :ph
      Array :growing_practices
    end

    def garden
      @garden ||= Garden.new
    end

    def validate
      validate_permissions
    end

    def execute
      set_params
      garden
    end

    def validate_permissions
      if @guide && (@guide.user != user)
        # TODO: Make a custom 'unauthorized' exception that we can rescue_from
        # in the controller.
        add_error :user,
                  :unauthorized_user,
                  'You cant create requirements for guides you dont own.'
      end
    end

    def set_params
      garden.user          = user
      # TODO: validate that the stage name is one
      # of stage options, or should we?
      garden.name           = name
      garden.location       = location if location
      garden.type           = type if type
      garden.average_sun    = average_sun if average_sun
      garden.soil_type      = soil_type if soil_type
      garden.ph             = ph if ph
      garden.save
    end
  end
end
