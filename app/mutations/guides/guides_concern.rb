module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    def valid_url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end

    def validate_image_url
      if featured_image.present? && !valid_url?(featured_image)
      add_error :featured_image,
              :invalid_url,
              'Must be a fully formed URL, including the HTTP:// or '\
              'HTTPS://'
      end
    end
  end
end