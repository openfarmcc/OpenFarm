module Gardens
  class UpdateGarden < Mutations::Command
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
      validate_images
    end

    def execute
      set_images
      @existing_garden.update(attributes)
      # todo growing practices
      @existing_garden.save
      @existing_garden
    end

    def validate_permissions
      if @existing_garden.user != user
        msg = 'You can only update gardens that belong to you.'
        add_error :garden, :not_authorized, msg
      end
    end

    def validate_images
      # TODO: this is getting repeated everywhere,
      # is there a way to put this into the pictures mutation?
      images && images.each do |pic|
        pic_id = "#{pic[:id]}" if pic[:id].present?
        pictures = @existing_garden.pictures if @existing_garden
        outcome = Pictures::CreatePicture.validate(url: pic[:image_url],
                                                   id: pic_id,
                                                   pictures: pictures)
        unless outcome.success?
          add_error :images,
                    :bad_format,
                    outcome.errors.message_list.to_sentence
        end
      end
    end

    def set_images
      # Delete all pictures
      # This is much simpler, less ping pong than what it was
      # and probably okay for now. However, this only works when S3
      # is enabled, because paperclip normally stores on system, not on URLs.
      @existing_garden.pictures.delete_all
      images && images.each do |img|
        Picture.from_url(img[:image_url],
                         @existing_garden)
      end
    end
  end
end
