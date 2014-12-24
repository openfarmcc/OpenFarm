module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    def validate_image_url
      if featured_image.present? && !featured_image.valid_url?
        add_error :featured_image,
                  :invalid_url,
                  'Must be a fully formed URL, including the HTTP:// or '\
                  'HTTPS://'
      end
    end

    def set_featured_image_async
      # TODO: Determine if this is actually getting ran in DJ. If not:
      # -- move to the model level
      # -- Pass in featured_image as a param.
      # -- handle_asynchronously :this_guy_right_her
      if featured_image
        guide.update_attributes(featured_image: URI(featured_image))
      end
    end
  end
end
