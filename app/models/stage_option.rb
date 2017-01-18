class StageOption
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :default_value
  field :description
  field :name
  field :order, type: Integer

  has_and_belongs_to_many :stage_action_options

  slug :name
end
