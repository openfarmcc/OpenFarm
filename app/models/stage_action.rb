class StageAction
  include Mongoid::Document
  embedded_in :stage

  embeds_many :pictures, cascade_callbacks: true, as: :photographic

  field :name
  field :overview
  field :time
  field :order

  accepts_nested_attributes_for :pictures
end
