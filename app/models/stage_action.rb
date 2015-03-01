class StageAction
  include Mongoid::Document
  embedded_in :stage

  field :name
  field :overview
  field :time
  field :order
end
