module Pictures
  class CreatePicture < Mutations::Command

    required do
      string :url
    end

    optional do
      string :id, empty: true
      array :pictures, class: Picture
    end

    def validate
      validate_picture
    end

    def execute

    end

    def validate_picture
      if id
        exist_pic = pictures.bsearch { |p| p[:id].to_s == id.to_s }
        if exist_pic && exist_pic.attachment.url != url
          add_error :images,
                    :changed_image, 'You can\'t change an existing image, '\
                    'delete it and upload an other image.'
        end
      elsif !url.valid_url?
        add_error :images,
                  :invalid_url, "'#{url}' is not a valid URL. "\
                  'Ensure that it is a fully formed URL (including HTTP://'\
                  ' or HTTPS://)'
      end
    end
  end
end
