module Stages
  class CreateStage < Mutations::Command
    required do
      model :user
      string :guide_id
      string :name
    end

    optional do
      array :where
      array :soil
      array :light
      string :length
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
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def set_params
      stage.guide          = @guide
      # TODO: validate that the stage name is one
      # of stage options, or should we?
      stage.name           = name
      stage.where          = where if where
      stage.soil           = soil if soil
      stage.light          = light if light
      stage.length         = length if length
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
