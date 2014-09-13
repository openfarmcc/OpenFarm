# a Crop is the basic searchable unit within OpenFarm. The term 'plant' was
# avoided to stay generic (ex: edible fungi).
class Crop
  include Mongoid::Document
  include Mongoid::Slug
  # For more info about search, see:
  # https://github.com/mauriciozaffari/mongoid_search
  include Mongoid::Search
  has_many :guides

  field :name# , localize: true
  field :common_names, type: Array
  validates_presence_of :name
  field :binomial_name
  field :description
  field :image
  #TODO: Add tags to sun_requirements and sowing_method. See mongoid_search docs
  field :sun_requirements
  field :sowing_method
  field :spread          , type: Integer
  field :days_to_maturity, type: Integer
  field :row_spacing     , type: Integer
  field :height          , type: Integer

  field :sowing_time, :type => Hash
  field :harvest_time, :type => Hash

  search_in :name, :binomial_name, :description
  slug :name
end
