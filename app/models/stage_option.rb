class StageOption
  include Mongoid::Document
  include Mongoid::Slug

  field :default_value
  field :description
  field :name
  field :order

  embeds_many :stage_options

  slug :name
end
