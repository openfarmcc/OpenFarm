class Stage
  include Mongoid::Document
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  belongs_to :guide

  field :name, type: String
  field :length, type: Integer # Length in days
  field :where, type: Array
  field :soil, type: Array
  field :light, type: Array

end
