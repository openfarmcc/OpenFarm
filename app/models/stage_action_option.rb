class StageActionOption
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  has_and_belongs_to_many :stage_option
end
