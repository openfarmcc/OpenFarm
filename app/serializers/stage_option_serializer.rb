# frozen_string_literal: true

class StageOptionSerializer < BaseSerializer
  attribute :default_value
  attribute :name
  attribute :slug
  attribute :description
  attribute :order

  has_many :stage_action_options
end
