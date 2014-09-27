module Stages
  class CreateStage < Mutations::Command

    required do
      model :guide
      model :user
      string :name
      string :instructions
    end

    optional do
      string :days_start
      string :days_end
    end

    def stage
      @stage ||= Stage.new
    end

    def validate
      validate_permissions
      validate_guide
    end

    def execute
      set_params
      stage
    end

    def validate_permissions
      if guide.user != user
        # TODO: Make a custom 'unauthorized' exception that we can rescue_from
        # in the controller.
        add_error :user,
                  :unauthorized_user,
                  'You can only update stages that belong to your guides.'
      end
    end

    def set_params
      stage.guide          = @guide
      # TODO: validate that the stage name is one 
      # of stage options, or should we?
      stage.name           = name
      stage.instructions   = instructions
      stage.days_start     = days_start if days_start
      stage.days_end       = days_end if days_end
      stage.save
    end

    def validate_guide
      @guide = Guide.find(guide)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide, :guide_not_found, msg
    end
  end
end
