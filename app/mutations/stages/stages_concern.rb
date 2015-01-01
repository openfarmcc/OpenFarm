module Stages
  # Place shared functionality between Stage mutations here to stay DRY.
  module StagesConcern
    def validate_images
      images && images.each do |url|
        unless url.valid_url?
          add_error :images, :invalid_url, "#{url} is not a valid URL. Ensure "\
            'that it is a fully formed URL (including HTTP:// or HTTPS://)'
        end
      end
    end

    def validate_actions
      actions && actions.each do |action|
        # Can this validation somehow be done by the action
        # mutation without having to also run the execute method?
        # A: It Can't, we need a valid stage to do so
        # And stage is nil at this point. If you're refactoring this
        # feel free to remove this comment!
        if !action[:name] || !action[:name].is_a?(String)

          add_error :actions, :invalid_name, 'Please provide a valid name.'
        end

        if !action[:overview] || !action[:overview].is_a?(String)

          add_error :actions, :invalid_overview, 'Please provide a valid '\
                    'overview.'
        end
      end
    end

    def set_pictures
      images && images.map do |url|
        Picture.from_url(url, @stage)
      end
    end

    def set_actions
      @stage.stage_actions.delete_all

      actions && actions.each do |action|
        StageActions::CreateStageAction.run(user: user,
                                            action: action,
                                            id: "#{@stage.id}")
      end
    end
  end
end
