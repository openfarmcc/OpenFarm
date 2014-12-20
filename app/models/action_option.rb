class ActionOption
  include Mongoid::Document
  embedded_in :stage_option

  field :name, type: String
  field :description, type: String
end
