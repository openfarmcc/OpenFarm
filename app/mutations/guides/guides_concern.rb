module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    def validate_image_url
      add_error :featured_image,
                :invalid_url,
                'Must be a fully formed URL, including the HTTP:// or '\
                'HTTPS://' if featured_image.present? && !featured_image.valid_url?
    end

    def set_featured_image_async
      guide.update_attributes(featured_image: URI(featured_image)) if featured_image
    end
  end
end
