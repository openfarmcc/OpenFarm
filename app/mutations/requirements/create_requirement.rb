module Requirements
  class CreateRequirement < Mutations::Command
    required do
      model :user
      string :guide_id
      string :name
      string :required
    end

    def requirement
      @requirement ||= Requirement.new
    end

    def validate
      validate_guide
      validate_permissions
    end

    def execute
      set_params
      requirement
    end

    def validate_guide
      @guide = Guide.find(guide_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide, :guide_not_found, msg
    end

    def validate_permissions
      if @guide && (@guide.user != user)
        msg = 'You cant create requirements for guides you did not create.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def set_params
      requirement.guide          = @guide
      # TODO: validate that the stage name is one
      # of stage options, or should we?
      requirement.name           = name
      requirement.required       = required
      requirement.save
    end
  end
end
