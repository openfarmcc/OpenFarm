class StageAction
  include Mongoid::Document
  embedded_in :stage

  field :name
  field :overview
  field :time
  field :order

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures
end
