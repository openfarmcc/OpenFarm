class CropDataSource
  include Mongoid::Document

  belongs_to :crop

  field :source_name, type: String
  field :reference, type: String
end
