# a Crop is the basic searchable unit within OpenFarm. The term 'plant' was
# avoided to stay generic (ex: edible fungi).
class Crop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  searchkick

  is_impressionable counter_cache: true,
                    column_name: :impressions_field,
                    unique: :session_hash
  field :impressions_field, default: 0

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
  # field :days_to_maturity, type: Integer
  field :row_spacing, type: Integer
  field :height, type: Integer

  # embeds_many :crop_times

  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures

  def search_data
    as_json only: [:name, :common_names, :binomial_name, :description,
                   :guides_count]
  end

  def main_image_path
    if pictures.present?
      pictures.first.attachment.url
    else
      # WARNING! MVC VIOLATION AHEAD!!!! =======================================
      # The fact that we are using polymorphic embedded documents means we would
      # need to add an extra build step to populate S3 and then add conditional
      # logic to figure out which class its embedded in to return the correct
      # URL.

      # If someone reading this has a better idea, I'd love to hear it. In the
      # meantime, I'm willing to look the other way and violate MVC in favor of
      # having less code to maintain. The current solution lets us keep the file
      # in source control instead of expecting the developer to upload it to an
      # S3 bucket when setting up new boxes.
      ActionController::Base.helpers.asset_path('baren_field.jpg')
    end
  end

  slug :name
end
