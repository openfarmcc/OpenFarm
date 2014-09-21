class GuideRequirementOption
  include Mongoid::Document

  field :default_value
  field :type
  field :name
  field :options, type: Array
end