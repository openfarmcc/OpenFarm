class Requirement
  include Mongoid::Document
  # https://github.com/mauriciozaffari/mongoid_search
  include Mongoid::Search
  belongs_to :guide

  field :name,        type: String
  field :requirement, type: String
  field :slug,        type: String 
  
  #TODO: validations

end
