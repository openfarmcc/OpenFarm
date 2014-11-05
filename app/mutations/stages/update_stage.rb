module Stages
  # TODO Start new naming convention: Stages::Update
  class UpdateStage < Mutations::Command
    attr_reader :pictures
    required do
      model :user
      model :stage
    end

    optional do
      string :name
      string :days_start
      string :instructions
      string :days_end
      array  :images, class: String, arrayize: true
    end

    def validate
      validate_permissions
      validate_images
    end

    def execute
      set_pictures
      set_params
      stage
    end

private

    def validate_permissions
      if stage.guide.user != user
        msg = 'You can only update stages that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def validate_images
      images && images.each do |url|
        unless url.valid_url?
          add_error :images, :invalid_url, "#{url} is not a valid URL. Ensure "\
            "that it is a fully formed URL (including HTTP:// or HTTPS://)"
        end
      end
    end

    def set_pictures
      images && images.map { |url| Picture.from_url(url, stage) }
    end

    def set_params
      # TODO: Should we wrap our request params in a hash and not keep them in a
      # root element? That way we could just update_attributes(stage_params)
      stage.instructions = instructions if instructions.present?
      stage.days_start   = days_start if days_start.present?
      stage.days_end     = days_end if days_end.present?
      stage.name         = name if name.present?
      stage.save
    end
  end
end
