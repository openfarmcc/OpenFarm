class Stage
  include Mongoid::Document
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  belongs_to :guide

  field :name, type: String
  field :stage_length, type: Integer # Length in days
  field :environment, type: Array
  field :soil, type: Array
  field :light, type: Array

end
