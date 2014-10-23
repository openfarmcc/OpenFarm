class Garden
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :user
  # TODO: information about the plants in the garden: placement, dates planted, guides used, etc

  field :name
  field :description
  validates_presence_of :user

  field :location # users can have gardens in different locations
  field :type # outdoor, indoor, hydroponic, etc
  field :average_sun # full, partial, etc
  field :soil_type # clay, high organic, etc
  field :ph # 0-14
  field :growing_practices, type: Array # organic, permaculutre, etc
end