class GardenCrop
  include Mongoid::Document
  embedded_in :garden
  has_one :crop
  has_one :guide
  field :quantity, type: Integer, default: 0
  field :stage, type: String, default: "Planted"
  field :sowed, type: Time
end