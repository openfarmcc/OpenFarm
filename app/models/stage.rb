class Stage
  include Mongoid::Document
  embeds_many :pictures, cascade_callbacks: true, as: :photographic

  belongs_to :guide

  field :name, type: String
  field :stage_length, type: Integer # Length in days
  field :environment, type: Array
  field :soil, type: Array
  field :light, type: Array

  field :order, type: Integer # Inherited from the stage_option

  embeds_many :stage_actions

  accepts_nested_attributes_for :pictures
end
