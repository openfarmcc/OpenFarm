module StageActions
  class UpdateStageAction < Mutations::Command
    include StageActions::StageActionsConcern
    include PicturesMixin

    required do
      model :user
      string :stage_id
      string :id
      hash :attributes do
        optional do
          string :name
          string :overview
          integer :order
          integer :time
          string :time_unit
        end
      end
    end

    optional { array :images, class: Hash, arrayize: true }

    def validate
      validate_stage stage_id
      validate_images images
      validate_permissions
    end

    def execute
      @action = @stage.stage_actions.find(id)
      @action.update_attributes(attributes)
      set_empty_time

      @action.save

      set_images images, @action
      @action.reload
      @action
    end

    def set_empty_time
      @action.time = nil if attributes[:time] == nil
      @action.time_unit = nil if attributes[:time_unit] == nil
    end

    def validate_permissions
      if @stage && (@stage.guide.user != user)
        msg =
          'You can only update actions for stages that belong to your ' \
            'guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
