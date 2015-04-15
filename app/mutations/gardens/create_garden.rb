module Gardens
  class CreateGarden < Mutations::Command
    required do
      model :user
      string :name
      hash :garden do
        optional do
          string :location
          string :description
          string :type
          string :average_sun
          string :soil_type
          boolean :is_private
          float :ph
          Array :growing_practices
        end
      end
    end

    def execute
      @garden = Garden.new(garden)
      @garden.user = user
      @garden.name = name
      # TODO: This is another spot where mongoid comparable error
      # happens
      @garden.save!
      @garden
    end
  end
end
