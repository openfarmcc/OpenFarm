module Requirements
  class CreateRequirement < Mutations::Command

    required do
      model :guide
      string :name
      string :requirement
    end

    def requirement
      @requirement ||= Requirement.new
    end

    def validate
      validate_guide
    end

    def execute
      set_params
      requirement
    end

    def set_params
      requirement.guide          = @guide
      requirement.name           = name
      requirement.requirement    = requirement
      requirement.save
    end

    def validate_guide
      @guide = Guide.find(guide)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide, :guide_not_found, msg
    end
  end
end
