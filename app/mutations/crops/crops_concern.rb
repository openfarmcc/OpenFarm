module Crops
  # Place shared functionality between Stage mutations here to stay DRY.
  module CropsConcern
    def validate_images
      images && images.each do |pic|
        unless pic[:image_url].valid_url?
          add_error :images,
                    :invalid_url, "'#{pic[:image_url]}' is not a valid URL. "\
                    'Ensure that it is a fully formed URL (including HTTP://'\
                    ' or HTTPS://)'
        end
      end
    end

    def set_pictures
      existing_pics = []
      images && images.map do |pic|
        if pic[:id]
          # Find the pictures with a given ID
          existing_pics.push(@existing_crop.pictures.find(pic[:id])._id)
        else
          existing_pics.push(Picture.from_url(pic[:image_url],
                                              @existing_crop)._id)
        end
      end
      @existing_crop.pictures.each do |pic|
        unless existing_pics.include? pic[:id]
          pic.remove()
        end
      end
    end
  end
end
