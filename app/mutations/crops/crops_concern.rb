module Crops
  # Place shared functionality between Stage mutations here to stay DRY.
  module CropsConcern
    # Complexity of this method is way too high. Let's refactor some time.
    #   - @RickCarlino
    def validate_images
      images && images.each do |pic|
        # If it's an existing picture with an ID.
        if pic[:id]
          exist_pic = @existing_crop.pictures.find(pic[:id])
          if exist_pic.attachment.url != pic[:image_url]
            add_error :images,
                      :changed_image, 'You can\'t change an existing image, '\
                      'delete it and upload an other image.'
          end
        elsif !pic[:image_url].valid_url?
            add_error :images,
                      :invalid_url, "'#{pic[:image_url]}' is not a valid URL. "\
                      'Ensure that it is a fully formed URL (including HTTP://'\
                      ' or HTTPS://)'
        end
      end
    end
    # I think the complexity seen here and in validate_images might indicate its
    # time to make crop pictures a nested resources.
    # TODO refactor this to be the same as in stages_concern.
    def set_pictures
      if images
        maybe_delete images
        maybe_create images
      end
    end

    # The amount of Ruby golf going on here is worrisome.
    def maybe_delete(images)
      # Get current picture IDs
      current_ids = @existing_crop.pictures.pluck(:id).map(&:to_s)
      # Get picture IDs provided in request
      dont_delete = images.map { |p| p[:id] }.map(&:to_s).compact
      # Find pictures IDs that exist, but were not provided
      do_delete   = current_ids - dont_delete
      # Delete pic IDs that were not provided in params.
      # FIXME: this is what mongoid is complaining about.
      @existing_crop.pictures.find(do_delete).map(&:destroy)
    end

    def maybe_create(images)
      images.map do |pic|
        Picture.from_url(pic[:image_url], @existing_crop) if !pic[:id].present?
      end
    end
  end
end
