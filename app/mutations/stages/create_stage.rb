module Stages
  class CreateStage < Mutations::Command
    required do
      model :user
      string :guide_id
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
      validate_guide
      validate_permissions
    end

    def execute
      set_params
      stage
    end

    def validate_permissions
      if @guide && (@guide.user != user)
        msg = 'You can only create stages for guides that belong to you.'
        fail OpenfarmErrors::NotAuthorized, msg
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
      @guide = Guide.find(guide_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide_id, :guide_not_found, msg
    end
  end
end
