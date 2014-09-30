class StageOption
  include Mongoid::Document
  include Mongoid::Slug

  field :default_value
  field :description
  field :name
  field :order

  slug :name
end
