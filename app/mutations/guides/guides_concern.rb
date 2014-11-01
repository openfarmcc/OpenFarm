module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  #  OMG LOOK AT HOW LONG THIS LINE IS WHY ISNT HOUND TELLING ME THAT IM WRONG RIGHT NOW I NEED AN ADULT!!!
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
      if featured_image
        guide.update_attributes(featured_image: URI(featured_image))
      end
    end
  end
end
