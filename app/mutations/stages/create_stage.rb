module Stages
  class CreateStage < Mutations::Command
    required do
      model :user
      string :guide_id
      string :name
    end

    optional do
      array :environment
      array :soil
      array :light
      integer :stage_length
      array  :images, class: String, arrayize: true
    end

    def stage
      @stage ||= Stage.new
    end

    def validate
      validate_guide
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
      if @guide && (@guide.user != user)
        msg = 'You can only create stages for guides that belong to you.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def validate_guide
      @guide = Guide.find(guide_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide_id, :guide_not_found, msg
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
      stage.guide          = @guide
      # TODO: validate that the stage name is one
      # of stage options, or should we?
      stage.name           = name
      stage.environment    = environment if environment
      stage.soil           = soil if soil
      stage.light          = light if light
      stage.stage_length   = stage_length if stage_length
      stage.save
    end
  end
end
