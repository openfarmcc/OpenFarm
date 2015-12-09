module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    # Complexity of this method is way too high. Let's refactor some time.
    #   - @RickCarlino
    def validate_images(images)
      images && images.each do |pic|
        pic_id = "#{pic[:id]}" if pic[:id].present?
        pictures = @guide.pictures if @guide
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

    def validate_time_span
    end

    def set_time_span
      if attributes[:time_span]
        @guide.time_span = TimeSpan.new(attributes[:time_span])
      end
    end

    def set_images
      # Delete all pictures
      # This is much simpler, less ping pong than what it was
      # and probably okay for now. However, this only works when S3
      # is enabled, because paperclip normally stores on system, not on URLs.
      @guide.pictures.delete_all
      images && images.each do |img|
          Picture.from_url(img[:image_url],
                         @guide)
      end
    end

  #   def set_featured_image_async
  #     # TODO: Determine if this is actually getting ran in DJ. If not:
  #     # -- move to the model level
  #     # -- Pass in featured_image as a param.
  #     # -- handle_asynchronously :this_guy_right_her
  #     if @guide.featured_image
  #       existing_url = @guide.featured_image
  #     end
  #     featured_image = attributes[:featured_image]
  #     if featured_image && featured_image != existing_url.to_s
  #       @guide.update_attributes(featured_image: URI(featured_image))
  #       # @guide.update_attributes(featured_image: URI(featured_image))
  #     end
  #   end
  # end
  end
end
