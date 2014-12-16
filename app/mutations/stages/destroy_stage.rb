module Stages
  class DestroyStage < Mutations::Command
    required do
      model :user
      string :id
    end

    def validate
      find_stage
      authorize_user
    end

    def execute
      @stage.destroy
    end

    def authorize_user
      if @stage && (@stage.guide.user != user)
        msg = 'You can only destroy stages that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def find_stage
      @stage = Stage.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a requirement with id #{id}."
      add_error :stage, :stage_not_found, msg
    end
  end
end
