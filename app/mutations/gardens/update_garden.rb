module Gardens
  class UpdateGarden < Mutations::Command
    include PicturesMixin

    required do
      model :user
      string :id

      hash :attributes do
        optional do
          string :name
          string :location
          string :description
          string :type
          string :average_sun
          string :soil_type
          float :ph
          array :growing_practices
        end
      end
    end

    optional do
      array :images, class: Hash, arrayize: true
    end

    def validate
      @existing_garden = Garden.find(id)
      validate_permissions
      validate_images(images, @existing_garden)
    end

    def execute

      @existing_garden.update(attributes)
      set_images(images, @existing_garden)
      @existing_garden.save
      @existing_garden
    end

    def validate_permissions
      if @existing_garden.user != user
        msg = 'You can only update gardens that belong to you.'
        add_error :garden, :not_authorized, msg
      end
    end
  end
end
