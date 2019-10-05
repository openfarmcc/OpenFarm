# frozen_string_literal: true

class CropsTagIndex
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'crops_tags_index'

  field :value, type: Integer
end
