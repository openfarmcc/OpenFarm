module StageActions
  class CreateStageAction < Mutations::Command
    required do
      model :user
      string :id
      hash :action do
        required do
          string :name
          string :overview
        end
      end
    end

    def validate
      validate_stage
      validate_permissions
    end

    def execute
      @stage.stage_actions.create(action)
    end

    private

    def validate_stage
      @stage = Stage.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a stage with id #{id}."
      add_error :id, :stage_not_found, msg
    end

    def validate_permissions
      if @stage && (@stage.guide.user != user)
        msg = 'You can only create actions for stages that belong to your '\
              'guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
