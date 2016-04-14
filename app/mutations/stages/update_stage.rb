module Stages
  # TODO Start new naming convention: Stages::Update
  class UpdateStage < Mutations::Command
    attr_reader :pictures
    include PicturesMixin
    include Stages::StagesConcern

    required do
      model :stage
      model :user
      hash :attributes do
        optional do
          string :name
          string :overview
          array :environment, nils: true
          array :soil, nils: true
          array :light, nils: true
          integer :stage_length
          integer :order
        end
      end
    end

    optional do
      array :images, class: Hash, arrayize: true
      array :actions, class: Hash, arrayize: true
    end

    def validate
      @stage = stage
      validate_permissions
      validate_images images, @stage
      validate_actions
    end

    def execute
      @stage.update! attributes

      set_images images, @stage
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
