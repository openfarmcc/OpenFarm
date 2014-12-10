module Stages
  # TODO Start new naming convention: Stages::Update
  class UpdateStage < Mutations::Command
    attr_reader :pictures

    include Stages::StagesConcern

    required do
      model :user
      model :stage
    end

    optional do
      string :name
      array :environment
      array :soil
      array :light
      integer :stage_length
      array  :images, class: String, arrayize: true
    end

    def validate
      validate_permissions
      validate_images
    end

    def execute
      set_pictures
      set_params
      stage
    end

private

    def validate_permissions
      if stage.guide.user != user
        msg = 'You can only update stages that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def set_params
      # TODO: Should we wrap our request params in a hash and not keep them in a
      # root element? That way we could just update_attributes(stage_params)
      stage.name           = name
      stage.environment    = environment if environment.present?
      stage.soil           = soil if soil.present?
      stage.light          = light if light.present?
      stage.stage_length   = stage_length if stage_length.present?
      stage.save
    end
  end
end
