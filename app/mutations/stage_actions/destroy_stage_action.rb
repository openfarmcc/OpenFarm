module StageActions
  class DestroyStageAction < Mutations::Command
    required do
      model :user
      string :id
      string :stage_id
    end

    def validate
      find_stage_action
      authorize_user
    end

    def execute
      @stage_action.destroy
    end

    def authorize_user
      if @stage_action && (@stage_action.stage.guide.user != user)
        msg = 'You can only destroy stage actions that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def find_stage_action
      @stage_action = Stage.find(stage_id).
          stage_actions.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a stage_action with id #{id}."
      add_error :stage_action, :stage_action_not_found, msg
    end
  end
end
