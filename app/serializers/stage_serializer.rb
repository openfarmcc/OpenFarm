# frozen_string_literal: true

class StageSerializer < BaseSerializer
  attribute :name
  attribute :soil
  attribute :environment
  attribute :light
  attribute :order
  attribute :stage_length
  attribute :overview

  has_one :guide
  has_one :time_span

  has_many :pictures
  has_many :stage_actions
end
