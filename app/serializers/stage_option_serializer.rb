class StageOptionSerializer < ApplicationSerializer
  attributes :default_value, :name, :slug, :description,
             :order

  has_many :stage_action_options
end
