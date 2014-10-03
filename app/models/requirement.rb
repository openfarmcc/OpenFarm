class Requirement
  include Mongoid::Document
  include Mongoid::Search
  belongs_to :guide

  validates_presence_of :guide

  field :name,        type: String
  field :required,    type: String
  field :slug,        type: String
end
