class GardenCrop
  include Mongoid::Document
  include Mongoid::History::Tracker # https://github.com/mongoid/mongoid-history#mongoid-history
  include Mongoid::Timestamps

  embedded_in :garden
  embeds_one :guide, class_name: 'Guide', inverse_of: nil
  embeds_one :crop, class_name: 'Crop', inverse_of: nil
  field :quantity, type: Integer, default: 0
  field :stage, type: String, default: 'Planted'
  field :sowed, type: Date, default: -> { Date.today }

  track_history on: [:stage, :sowed],    # track title and body fields only, default is :all
                scope: :garden,
                version_field: :version, # adds "field :version, :type => Integer" to track current version, default is :version
                track_create: :false,    # track document creation, default is false
                track_update: :true,     # track document updates, default is true
                track_destroy: :false    # track document destruction, default is false

  accepts_nested_attributes_for :guide
  accepts_nested_attributes_for :crop
end
