module Requirements
  class UpdateRequirements < Mutations::Command

    required do
      string :id
      model :guide
      string :name
      string :requirement
    end

    def validate
      validate_permissions
    end

    def execute
      set_valid_params
      requirement
    end

    def validate_permissions
      if requirement.guide.user != user
        # TODO: Make a custom 'unauthorized' exception that we can rescue_from
        # in the controller.
        add_error :user,
                  :unauthorized_user,
                  'You can only update requirements that you own.'
      end
    end

    def set_valid_params
      # TODO: Probably a DRYer way of doing this.
      requirement.name           = name if name.present?
      requirement.requirement    = requirement if requirement.present?

      requirement.save
    end
  end
end
