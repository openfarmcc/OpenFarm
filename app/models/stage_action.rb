class StageAction
  include Mongoid::Document
  embedded_in :stage

  field :name
  field :overview
  field :time
  field :time_unit
  field :order

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures

  # Warning! This is a _bit_ of hack. Because delayed_job_shallow_mongoid
  # does a find() on StageAction when trying to add anything to it, it seems
  # and StageAction is an embedded instance, it can't actually find
  # a StageAction for the ID, because it's not looking in the right place
  # So instead we overwrite the find function to locate the stage action
  # within all stages.
  def self.find(id)
    return nil if id.nil? || id.blank?

    id = BSON::ObjectId.from_string(id) if id.is_a?(String)

    Stage.where("stage_actions._id" => id).first.stage_actions.where({_id: id}).first

  end
end
