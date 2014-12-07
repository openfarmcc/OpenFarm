class Stage
  include Mongoid::Document
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  belongs_to :guide

  field :name, type: String
  field :days_start, type: Integer
  field :days_end, type: Integer
  field :instructions, type: String
end
