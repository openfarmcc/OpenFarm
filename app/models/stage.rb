class Stage
  include Mongoid::Document
  # https://github.com/mauriciozaffari/mongoid_search
  include Mongoid::Search
  
  belongs_to :guide

  field :name, type: String
  field :days_start, type: Integer
  field :days_end, type: Integer
  field :instructions, type: String
  field :slug, type: String

  #TODO: validations
  
end
