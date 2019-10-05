# frozen_string_literal: true

class CropDataSource
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :crops

  field :source_name, type: String
  field :reference, type: String
end
