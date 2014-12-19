# a Crop is the basic searchable unit within OpenFarm. The term 'plant' was
# avoided to stay generic (ex: edible fungi).
class Crop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  searchkick
  # history tracking all Crop documents
  # note: tracking will not work until #track_history is invoked
  include Mongoid::History::Trackable

  is_impressionable counter_cache: true,
                    column_name: :impressions,
                    unique: :session_hash
  field :impressions, default: 0

  has_many :guides
  field :guides_count, type: Fixnum, default: 0

  field :name
  field :common_names, type: Array
  validates_presence_of :name
  field :binomial_name
  field :description
  belongs_to :crop_data_source
  field :sun_requirements
  field :sowing_method
  field :spread, type: Integer
  field :days_to_maturity, type: Integer
  field :row_spacing, type: Integer
  field :height, type: Integer

  field :sowing_time, type: Hash
  field :harvest_time, type: Hash

  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures

  def search_data
    as_json only: [:name, :common_names, :binomial_name, :description]
  end
  slug :name


  # See https://github.com/aq1018/mongoid-history
  track_history on: [:description, :image],
                modifier_field: :modifier,
                version_field: :version
end
