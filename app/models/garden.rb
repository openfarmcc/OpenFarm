class Garden
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  validates_presence_of :user

  after_save :reindex_guides

  embeds_many :garden_crops
  accepts_nested_attributes_for :garden_crops

  field :name
  field :description
  field :is_private, type: Mongoid::Boolean, default: false

  field :location, type: String # users can have gardens in different locations (geographic)
  field :type, type: String # outdoor, indoor, hydroponic, etc
  field :average_sun, type: String # full, partial, etc
  field :soil_type, type: String # clay, high organic, etc
  field :ph, type: Float # 0-14
  field :growing_practices, type: Array # organic, permaculutre, etc

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures
  scope :is_public, -> { where(is_private: true) }

  protected

  def reindex_guides
    ReindexGuidesJob.perform_later
  end
end
