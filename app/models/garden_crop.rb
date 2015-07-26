class GardenCrop
  include Mongoid::Document
  embedded_in :garden
  embeds_one :guide, class_name: 'Guide', inverse_of: nil
  embeds_one :crop, class_name: 'Crop', inverse_of: nil
  field :quantity, type: Integer, default: 0
  field :stage, type: String, default: 'Planted'
  field :sowed, type: Date, default: -> { Date.today }

  accepts_nested_attributes_for :guide
  accepts_nested_attributes_for :crop
end
