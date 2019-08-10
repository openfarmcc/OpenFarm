# a Crop is the basic searchable unit within OpenFarm. The term 'plant' was
# avoided to stay generic (ex: edible fungi).
class Crop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Taggable

  searchkick

  field :impressions_field, default: 0, type: Integer

  has_many :guides
  field :guides_count, type: Integer, default: 0
  field :svg_icon
  validates_length_of :svg_icon,
     minimum: 11,           # Size of empty "<svg></svg>" tag.
     maximum: 75.kilobytes, # 3x larger than largest icon.
     allow_blank: true
  field :description
  belongs_to :crop_data_source
  field :sun_requirements
  field :sowing_method
  field :spread, type: Integer
  field :growing_degree_days, type: Integer
  field :minimum_temperature, type: Integer # In Celcius
  field :row_spacing, type: Integer
  field :height, type: Integer

  # Naming. This is tricky.
  # See https://github.com/openfarmcc/OpenFarm/issues/641
  field :binomial_name

  field :genus
  field :species

  field :taxon, type: String
  validates_inclusion_of :taxon,
                         in: %w(Species Genus Family Order Class Phylum Kingdom Domain Life Other),
                         message: "%{value} is not a valid taxon",
                         allow_nil: true

  field :cultivar_name

  field :name
  field :common_names, type: Array
  validates :name, presence: true

  has_and_belongs_to_many :companions,
                          class_name: 'Crop',
                          inverse_of: :companions

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures

  slug :name

  after_save :backlink_companion_crops

  def search_data
    as_json only: [:name, :common_names, :binomial_name, :description,
                   :guides_count]
  end

  def main_image_path(args={})
    if pictures.present?
      pictures.first.attachment.url(args[:size] || :large)
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
      if args[:front_page]
        ActionController::Base.helpers.asset_path('baren_field_310x310.jpg')
      else
        ActionController::Base.helpers.asset_path('baren_field_square.jpg')
      end
    end
  end

  # This is nasty, but it's because mongoid doesn't do
  # Has And Belongs To Many relationships that point to
  # self very well.
  def backlink_companion_crops
    # clean up what was
    if companion_ids_was.present?
      companion_ids_was.each do |oldcomp|
        oldcomp = Crop.find(oldcomp)
        # We explicitely skip this backlink validation here
        # again otherwise we'll loop indefinitely.
        Crop.skip_callback(:save, :after, :backlink_companion_crops)
        oldcomp.companions.delete(self)
        Crop.set_callback(:save, :after, :backlink_companion_crops)
      end
    end

    # now link these things
    if companions.present?
      companions.each do |new_companion|
        new_companions = new_companion.companions + [self]
        # We explicitely skip this backlink validation here
        # again otherwise we'll loop indefinitely.
        Crop.skip_callback(:save, :after, :backlink_companion_crops)
        new_companion.set(companions: new_companions.uniq)
        Crop.set_callback(:save, :after, :backlink_companion_crops)
      end
    end
  end
end
