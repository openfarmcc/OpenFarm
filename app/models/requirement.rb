class Requirement
  include Mongoid::Document
  belongs_to :guide

  validates :guide, presence: true

  field :name,        type: String
  field :required,    type: String
  field :slug,        type: String
end
