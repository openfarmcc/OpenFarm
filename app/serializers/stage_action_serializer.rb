class StageActionSerializer < BaseSerializer
  attribute :name
  attribute :overview
  attribute :time
  attribute :order

  has_many :pictures
end
