class CropsTagIndex
  include Mongoid::Document
  store_in collection: "crops_tags_index"

  field :value, type: Integer
end