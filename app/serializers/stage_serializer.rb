class StageSerializer < ApplicationSerializer
  attributes :_id, :guide, :name, :stage_length, :soil, :environment,
             :light, :pictures
end
