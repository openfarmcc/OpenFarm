module Gardens
  class UpdateGarden < Mutations::Command
    required do
      model :user
      model :garden

      hash :attributes do
        optional do
          string :name
          string :location
          string :description
          string :type
          string :average_sun
          string :soil_type
          integer :ph
        end
      end
    end

    optional do
      array :images, class: Hash, arrayize: true
      array :growing_practices
    end

    def validate
      validate_permissions
      validate_images
    end

    def execute
      garden.update(attributes)
      # todo growing practices
      garden.save
      garden
    end

    def validate_permissions
      if garden.user != user
        msg = 'You can only update gardens that belong to you.'
        add_error :garden, :not_authorized, msg
      end
    end

    def validate_images
      images && images.each do |pic|
        pic_id = "#{pic[:id]}" if pic[:id].present?
        pictures = garden.pictures if garden
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
  end
end
