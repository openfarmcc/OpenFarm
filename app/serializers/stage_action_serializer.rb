class StageActionSerializer < ApplicationSerializer
  attributes :_id, :name, :overview, :time, :order

  has_many :pictures
end
