module Requirements
  class DestroyRequirement < Mutations::Command
    required do
      model :user
      string :id
    end

    def validate
      find_requirement
      authorize_user
    end

    def execute
      @requirement.destroy
    end

    def authorize_user
      if @requirement && (@requirement.guide.user != user)
        msg = 'You can only destroy requirements that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def find_requirement
      @requirement = Requirement.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a requirement with id #{id}."
      add_error :requirement, :requirement_not_found, msg
    end
  end
end
