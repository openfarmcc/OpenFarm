module Stages
  # Place shared functionality between Stage mutations here to stay DRY.
  module StagesConcern
    def validate_images
      images && images.each do |url|
        unless url.valid_url?
          add_error :images, :invalid_url, "#{url} is not a valid URL. Ensure "\
            'that it is a fully formed URL (including HTTP:// or HTTPS://)'
        end
      end
    end

    def set_pictures
      puts images
      images && images.map { |url| Picture.from_url(url, stage) }
    end
  end
end
