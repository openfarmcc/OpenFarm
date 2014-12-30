module Stages
  class CreateStage < Mutations::Command
    include Stages::StagesConcern

    required do
      model :user
      string :guide_id

      hash :stage do
        required do
          string :name
        end

        optional do
          array :environment
          array :soil
          array :light
          integer :stage_length
        end
      end
    end

    optional do
      array :actions, class: Hash, arrayize: true
      array :images, class: String, arrayize: true
    end

    def validate
      validate_guide
      validate_permissions
      validate_images
      validate_actions
    end

    def execute
      @stage ||= Stage.new(stage)
      @stage.guide = @guide
      @stage.save
      set_pictures
      set_actions

      # TODO: Why is this record being reloaded? Possible refactor target:
      @stage.save
      @stage.reload
      @stage
    end

    private

    def validate_guide
      @guide = Guide.find(guide_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{guide_id}."
      add_error :guide_id, :guide_not_found, msg
    end

    def validate_permissions
      if @guide && (@guide.user != user)
        msg = 'You can only create stages for guides that belong to you.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
