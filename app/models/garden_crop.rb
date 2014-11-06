class GardenCrop
  include Mongoid::Document
  embedded_in :garden
  embeds_one :guide, class_name: "Guide", inverse_of: nil
  field :quantity, type: Integer, default: 0
  field :stage, type: String, default: "Planted"
  field :sowed, type: DateTime, default: -> { Date.today }
end
