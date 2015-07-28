module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    def validate_image_url
      featured_image = attributes[:featured_image]
      if featured_image.present? && !featured_image.valid_url?
        outcome = Pictures::CreatePicture.validate(url: featured_image)
        unless outcome.success?
          add_error :featured_image,
                    :bad_format,
                    'Must be a fully formed URL, including the HTTP:// or '\
                    'HTTPS://'
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

    def set_featured_image_async
      # TODO: Determine if this is actually getting ran in DJ. If not:
      # -- move to the model level
      # -- Pass in featured_image as a param.
      # -- handle_asynchronously :this_guy_right_her
      if @guide.featured_image
        existing_url = @guide.featured_image
      end
      featured_image = attributes[:featured_image]
      if featured_image && featured_image != existing_url.to_s
        @guide.update_attributes(featured_image: URI(featured_image))
        # @guide.update_attributes(featured_image: URI(featured_image))
      end
    end
  end
end
