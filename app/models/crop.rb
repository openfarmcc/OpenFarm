# a Crop is the basic searchable unit within OpenFarm. The term 'plant' was
# avoided to stay generic (ex: edible fungi).
class Crop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  # For more info about search, see:
  # https://github.com/mauriciozaffari/mongoid_search
  include Mongoid::Search

  # history tracking all Crop documents
  # note: tracking will not work until #track_history is invoked
  include Mongoid::History::Trackable

  has_many :guides

  field :name# , localize: true
  field :common_names, type: Array
  validates_presence_of :name
  field :binomial_name
  field :description
  field :image
  has_many :crop_data_sources
  #TODO: Add tags to sun_requirements and sowing_method. See mongoid_search docs
  field :sun_requirements
  field :sowing_method
  field :spread, type: Integer
  field :days_to_maturity, type: Integer
  field :row_spacing, type: Integer
  field :height, type: Integer

  field :sowing_time, type: Hash
  field :harvest_time, type: Hash

  search_in :name, :binomial_name, :description
  slug :name

  track_history   :on => [:description, :image],       # track title and body fields only, default is :all
                  :modifier_field => :modifier, # adds "belongs_to :modifier" to track who made the change, default is :modifier
                  :modifier_field_inverse_of => :nil, # adds an ":inverse_of" option to the "belongs_to :modifier" relation, default is not set
                  :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                  :track_create   =>  false,    # track document creation, default is false
                  :track_update   =>  true,     # track document updates, default is true
                  :track_destroy  =>  false
end
