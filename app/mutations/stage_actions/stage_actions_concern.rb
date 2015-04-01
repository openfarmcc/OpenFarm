module StageActions
  # Place shared functionality between Stage mutations here to stay DRY.
  module StageActionsConcern
    def validate_images
      images && images.each do |pic|
        pic_id = "#{pic[:id]}" if pic[:id].present?
        pictures = @action.pictures if @action
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
      @action.pictures.delete_all
      images && images.each do |img|
        Picture.from_url(img[:image_url],
                         @action)
      end
    end
  end
end
