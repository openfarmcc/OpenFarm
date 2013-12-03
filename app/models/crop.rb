# a Crop is the basic searchable unit within OpenFarm. The term 'plant' was
# avoided to stay generic (ex: edible fungi).
class Crop
  include Mongoid::Document
  # For more info about search, see:
  # https://github.com/mauriciozaffari/mongoid_search
  include Mongoid::Search

  field :name
  validates_presence_of :name
  field :binomial_name
  field :description
  #TODO: Add tags to sun_requirements and sowing_method. See mongoid_search docs
  field :sun_requirements
  field :sowing_method
  field :spread          , type: Integer
  field :days_to_maturity, type: Integer
  field :row_spacing     , type: Integer
  field :height          , type: Integer

  search_in :name, :binomial_name, :description
end
