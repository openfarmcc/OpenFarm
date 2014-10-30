module Stages
  class UpdateStage < Mutations::Command
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
    end

    def execute
      set_valid_params
      stage
    end

private
    def validate_images
      images.each do |url|
        invalidate_url(url) unless url.valid_url?
      end
    end

    def invalidate_url(url)
      add_error :images, :invalid_url, "#{url} is not a valid URL. Ensure that"\
        " it is a fully formed URL (including HTTP:// or HTTPS://)"
    end

    def validate_permissions
      if stage.guide.user != user
        msg = 'You can only update stages that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def set_valid_params
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
