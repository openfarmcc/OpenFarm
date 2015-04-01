class StageSerializer < ApplicationSerializer
  attributes :_id, :guide, :name, :soil, :environment,
             :light, :order, :stage_length

  has_many :pictures
  has_one :time_span
  has_many :stage_actions
end
