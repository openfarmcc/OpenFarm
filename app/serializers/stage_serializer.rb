class StageSerializer < BaseSerializer
  attribute :name
  attribute :soil
  attribute :environment
  attribute :light
  attribute :order
  attribute :stage_length

  has_one :guide
  has_many :pictures
  has_one :time_span
  has_many :stage_actions
end
