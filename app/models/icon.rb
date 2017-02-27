# frozen_string_literal: true
# an *SVG* Icon used by OpenFarm and other apps that feed into the OpenFarm API.
class Icon
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Taggable

  searchkick

  field :description
  field :name
  field :svg

  validates :name, presence: true
  validates :svg, presence: true

  slug :name

  # Keep track of authors.
  belongs_to :user
  validates_presence_of :user

  after_save :reindex_icons

  def reindex_icons
    ReindexIconsJob.perform_later
  end

  def search_data
    as_json only: [:name, :description]
  end

end
