class StageAction
  include Mongoid::Document
  embedded_in :stage

  field :name, type: String
  field :overview, type: String
end
