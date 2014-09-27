module Stages
  class CreateStage < Mutations::Command

    required do
      model :guide
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
    end

    def execute
      set_params
      stage
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
