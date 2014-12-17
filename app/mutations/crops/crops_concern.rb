module Crops
  # Place shared functionality between Stage mutations here to stay DRY.
  module CropsConcern
    def validate_images
      images && images.each do |url|
        unless url.valid_url?
          add_error :images,
                    :invalid_url, "#{url} is not a valid URL. Ensure "\
            'that it is a fully formed URL (including HTTP:// or HTTPS://)'
        end
      end
    end

    def set_pictures
      images && images.map { |url| Picture.from_url(url, @existing_crop) }
    end
  end
end
