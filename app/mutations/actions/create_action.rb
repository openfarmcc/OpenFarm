module Actions
  class CreateAction < Mutations::Command
    include Stages::StagesConcern

    required do
      model :user
      string :stage
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
      @action ||= Action.new(action)
    end

    private

    def validate_permissions
      if @stage && (@stage.guide.user != user)
        msg = 'You can only create actions for stages that belong to your'\
              'guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def validate_stage
      @stage = Stage.find(stage_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a stage with id #{stage.id}."
      add_error :stage_id, :stage_not_found, msg
    end
  end
end
