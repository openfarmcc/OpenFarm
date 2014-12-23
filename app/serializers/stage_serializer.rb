class StageSerializer < ApplicationSerializer
  attributes :_id, :guide, :name, :stage_length, :soil, :environment,
             :light

  has_many :pictures
  embeds_many :stage_actions
end
