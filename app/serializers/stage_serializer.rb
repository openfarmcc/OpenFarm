class StageSerializer < ApplicationSerializer
  attributes :_id, :guide, :name, :stage_length, :soil, :environment,
             :light, :order

  has_many :pictures
  has_many :stage_actions
end
