# frozen_string_literal: true

class StageActionOption
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  has_and_belongs_to_many :stage_option
end
