module Stages
  # TODO Start new naming convention: Stages::Update
  class UpdateStage < Mutations::Command
    attr_reader :pictures

    include Stages::StagesConcern

    required do
      model :stage
      model :user
      hash :attributes do
        optional do
          string :name
          array :environment
          array :soil
          array :light
          integer :stage_length
          integer :order
        end
      end
    end

    optional do
      array :images, class: String, arrayize: true
      array :actions, class: Hash, arrayize: true
    end

    def validate
      @stage = stage
      validate_permissions
      validate_images
      validate_actions
    end

    def execute
      @stage.update(attributes)
      set_pictures
      set_actions
      @stage.save
      @stage.reload
    end

    private

    def validate_permissions
      if @stage.guide.user != user
        msg = 'You can only update stages that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
