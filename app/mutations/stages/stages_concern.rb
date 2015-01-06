module Stages
  # Place shared functionality between Stage mutations here to stay DRY.
  module StagesConcern
    def validate_images
      images && images.each do |pic|
        pic_id = "#{pic[:id]}" if pic[:id].present?
        outcome = Pictures::CreatePicture.validate(url: pic[:image_url],
                                                   id: pic_id,
                                                   pictures: stage.pictures)

        unless outcome.success?
          add_error :images,
                    :bad_format,
                    outcome.errors.message_list.to_sentence
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

    def set_images
      # puts "setting images"
      # stage.pictures.each do |existing_picture|
      #   puts "existing picture #{existing_picture}"
      # end
      images && images.each do |img|
        puts img
        Picture.from_url(img[:image_url],
                         @stage)
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
