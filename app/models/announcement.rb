class Crop
  include Mongoid::Document

  field :message
  field :starts_at, type: DateTime
  field :ends_at, type: DateTime