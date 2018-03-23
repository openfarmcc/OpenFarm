module Stages
  # Place shared functionality between Stage mutations here to stay DRY.
  module StagesConcern
    def validate_actions
      actions && actions.each do |action|
        # Can this validation somehow be done by the action
        # mutation without having to also run the execute method?
        # A: It Can't, we need a valid stage to do so
        # And stage is nil at this point. There might be a way around this
        # using some mutation settings. If you're refactoring this
        # feel free to remove this comment!
        if !action[:name] || !action[:name].is_a?(String) || action[:name] == ''
          add_error :actions,
                    :invalid_name,
                    "'#{action[:name]}' is not a valid action name"
        end

        validate_images(action[:images])
      end
    end

    def set_actions
      actions && actions.each do |action|
        if action[:id]
          @outcome = StageActions::UpdateStageAction.run(user: user,
                                                         attributes: action,
                                                         images: action[:images],
                                                         stage_id: "#{@stage.id}",
                                                         id: action[:id])

        else
          @outcome = StageActions::CreateStageAction.run(user: user,
                                                         attributes: action,
                                                         images: action[:images],
                                                         id: "#{@stage.id}")
        end
      end
    end
  end
end
