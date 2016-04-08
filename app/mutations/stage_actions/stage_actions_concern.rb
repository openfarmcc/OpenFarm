module StageActions
  # Place shared functionality between Stage mutations here to stay DRY.
  module StageActionsConcern
    def validate_stage(id)
      @stage = Stage.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a stage with id #{id}."
      add_error :id, :stage_not_found, msg
    end
  end
end
