module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    def validate_image_url
      featured_image = attributes[:featured_image]
      if featured_image.present? && !featured_image.valid_url?
        add_error :featured_image,
                  :invalid_url,
                  'Must be a fully formed URL, including the HTTP:// or '\
                  'HTTPS://'
      end
    end

    def validate_time_span
    end

    def set_time_span
      if time_span
        @guide.time_span = TimeSpan.new(time_span)
      end
    end

    def set_featured_image_async
      # TODO: Determine if this is actually getting ran in DJ. If not:
      # -- move to the model level
      # -- Pass in featured_image as a param.
      # -- handle_asynchronously :this_guy_right_her
      featured_image = attributes[:featured_image]
      if featured_image
        # TODO: My suspicion is that this is what triggers the MONGOID errors
        @guide.update_attributes(featured_image: URI(featured_image))
      end
    end
  end
end
