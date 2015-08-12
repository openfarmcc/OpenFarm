module Stages
  # Place shared functionality between Stage mutations here to stay DRY.
  module StagesConcern
    def validate_images(images)
      images && images.each do |pic|
        pic_id = "#{pic[:id]}" if pic[:id].present?
        pictures = @stage.pictures if @stage
        outcome = Pictures::CreatePicture.validate(url: pic[:image_url],
                                                   id: pic_id,
                                                   pictures: pictures)

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
        # And stage is nil at this point. There might be a way around this
        # using some mutation settings. If you're refactoring this
        # feel free to remove this comment!
        if !action[:name] || !action[:name].is_a?(String)

          add_error :actions, :invalid_name, 'Please provide a valid name.'
        end

        # if !action[:overview] || !action[:overview].is_a?(String)

        #   add_error :actions, :invalid_overview, 'Please provide a valid '\
        #             'overview.'
        # end

        validate_images(action[:images])
      end
    end

    def set_images
      # Delete all pictures
      # This is much simpler, less ping pong than what it was
      # and probably okay for now. However, this only works when S3
      # is enabled, because paperclip normally stores on system, not on URLs.
      @stage.pictures.delete_all
      images && images.each do |img|
        Picture.from_url(img[:image_url],
                         @stage)
      end
    end

    def set_actions
      @stage.stage_actions.delete_all

      actions && actions.each do |action|
        @outcome = StageActions::CreateStageAction.run(user: user,
                                                       attributes: action,
                                                       images: action[:images],
                                                       id: "#{@stage.id}")
        puts "WAS IT A SUCCESS?", @outcome.success?
        unless @outcome.success?
          puts @outcome.errors.message_list
        end
      end
    end
  end
end
