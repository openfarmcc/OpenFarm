# frozen_string_literal: true

class Stage
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_one :time_span, cascade_callbacks: true, as: :timed
  accepts_nested_attributes_for :time_span

  belongs_to :guide

  field :name, type: String
  field :stage_length, type: Integer # Length in days
  field :environment, type: Array
  field :soil, type: Array
  field :light, type: Array
  field :overview

  field :order, type: Integer # Inherited from the stage_option

  embeds_many :stage_actions
  accepts_nested_attributes_for :stage_actions

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures
end
