# frozen_string_literal: true

module Pictures
  class CreatePicture < Mutations::Command
    required { string :url }

    optional do
      string :id, empty: true
      array :pictures, class: Picture
      # model :photographic, class: Object, nil: false

      # TODO Here's another alternative solution for refactoring, mutation's
      # ducktype check https://github.com/cypriss/mutations/blob/master/lib/mutations/duck_filter.rb
    end

    def validate
      validate_picture
    end

    def execute
      # Still needs to be figured out.
    end

    def validate_picture
      storage_type = Paperclip::Attachment.default_options[:storage]
      test_or_filesystem = storage_type.to_s != 'filesystem' || Rails.env.to_s == 'test'
      if id
        exist_pic = pictures.bsearch { |p| p[:id].to_s == id.to_s }
        if exist_pic && exist_pic.attachment.url != url
          add_error :images,
                    :changed_image,
                    "You can't change an existing image, " \
                      'delete it and upload an other image.'
        end
        # This might be the wrong way to test this (what with checking the env
        # variable)
      elsif !url.valid_url? && test_or_filesystem
        add_error :images,
                  :invalid_url,
                  "'#{url}' is not a valid URL. " \
                    'Ensure that it is a fully formed URL (including HTTP://' \
                    ' or HTTPS://)'
      end
    end
  end
end
