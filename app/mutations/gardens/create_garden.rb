module Gardens
  class CreateGarden < Mutations::Command
    required do
      model :user
      string :name
    end

    optional do
      string :location
      string :description
      string :type
      string :average_sun
      string :soil_type
      float :ph
      Array :growing_practices
    end

    def garden
      @garden ||= Garden.new
    end

    def execute
      set_params
      garden
    end

    def set_params
      garden.user          = user
      garden.name           = name
      garden.location       = location if location
      garden.description    = description if description
      garden.type           = type if type
      garden.average_sun    = average_sun if average_sun
      garden.soil_type      = soil_type if soil_type
      garden.ph             = ph if ph
      garden.save
    end
  end
end
