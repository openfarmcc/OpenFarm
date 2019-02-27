class Guide
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Slug
  include Mongoid::Timestamps

  attr_accessor :current_user_compatibility_score

  searchkick(callbacks: :async)

  # The below seems to have made no difference, but it's based on:
  # https://github.com/ankane/searchkick#stay-synced
  # and the recommendations here:
  # https://github.com/ankane/searchkick/issues/373#issuecomment-71967887
  # Though it can probably be tweaked further.
  scope :search_import, -> { includes(:user) }

  is_impressionable counter_cache: true,
                    column_name: :impressions_field,
                    unique: :session_hash

  field :impressions_field, default: 0, type: Integer

  belongs_to :crop, counter_cache: true
  belongs_to :user
  has_many :stages

  field :draft, type: Boolean, default: true

  embeds_one :time_span, cascade_callbacks: true, as: :timed

  field :name
  field :location
  field :overview
  field :practices, type: Array
  field :completeness_score, default: 0
  field :popularity_score, default: 0

  field :times_favorited, type: Integer, default: 0

  validates_presence_of :crop, :name

  field :processing_pictures, type: Integer, default: 0
  embeds_many :pictures, cascade_callbacks: true, as: :photographic
  accepts_nested_attributes_for :pictures

  # Points to the index of images which should
  # be the featured image
  field :featured_image, type: Integer

  slug :name, history: true

  after_save :calculate_completeness_score
  # Maybe Popularity Score should be updated more frequently?
  after_save :calculate_popularity_score

  accepts_nested_attributes_for :time_span

  def self.sorted_for_user(guides, user)
    if user
      guides = guides.sort_by do |guide|
        guide.compatibility_score(user)
        guide.current_user_compatibility_score = guide.compatibility_score(user)
        guide.current_user_compatibility_score
      end
      guides.reverse
    else
      guides
    end
  end

  def owned_by?(current_user)
    !!(current_user && user == current_user)
  end

  def search_data
    as_json only: [:name, :overview, :crop_id, :draft, :compatibilities]
    # We changed this to as_json ^ because it was causing weird nesting.
    # Not sure that this should be a problem though, it's been filed:
    # https://github.com/ankane/searchkick/issues/595

    # {
    #   name: name,
    #   overview: overview,
    #   crop_id: crop_id,
    #   draft: draft,
    #   compatibilities: compatibilities
    # }
  end

  def compatibilities
    return @compatibilities if defined?(@compatibilities)

    @compatibilities = []

    User.includes(:gardens).each do |user|
      @compatibilities << {
        user_id: user.id.to_s, score: compatibility_score(user).to_i,
      }
    end

    @compatibilities
  end

  def basic_needs(current_user)
    return nil unless current_user
    return nil if current_user.gardens.empty?

    first_garden = current_user.gardens.first

    # We should probably store these in the DB
    basic_needs = [{ name: "Sun / Shade",
                    slug: "sun-shade",
                    overlap: [],
                    total: [],
                    percent: 0,
                    user: first_garden.average_sun,
                    garden: first_garden.name }, {
      name: "Location",
      slug: "location",
      overlap: [],
      total: [],
      percent: 0,
      user: first_garden.type,
      garden: first_garden.name,
    }, {
      name: "Soil Type",
      slug: "soil",
      overlap: [],
      total: [],
      percent: 0,
      user: first_garden.soil_type,
      garden: first_garden.name,
    }, {
      name: "Practices",
      slug: "practices",
      overlap: [],
      total: [],
      percent: 0,
      user: first_garden.growing_practices,
      garden: first_garden.name,
    }]

    # Still have to implement:
    # pH Range, Temperature, Water Use, Practices,
    # Time Commitment, Physical Ability, Time of Year

    find_overlap_in basic_needs
  end

  def compatibility_score(current_user)
    return current_user_compatibility_score if current_user_compatibility_score

    return nil unless current_user
    return nil if current_user.gardens.empty?

    count = 0

    sum = basic_needs(current_user).inject(0) do |memo, n|
      count += 1
      n[:percent] ? memo + n[:percent] : memo
    end

    (sum.to_f / count * 100).round
  end

  def compatibility_label(current_user)
    if current_user_compatibility_score
      score = current_user_compatibility_score
    else
      score = compatibility_score(current_user)
    end

    if score.nil?
      return ""
    elsif score > 75
      return "high"
    elsif score > 50
      return "medium"
    else
      return "low"
    end
  end

  protected

  # TODO: Fairly simplistic. This should be expanded to somehow take into
  # consideration stages and selected practices
  def calculate_completeness_score
    total = 0.0
    counted = 0.0
    fields.keys.each do |key|
      total += 1
      if self[key]
        counted += 1
      end
    end

    write_attributes(completeness_score: counted / total)
  end

  # TODO: Fairly simplistic. Should probably be normalized properly.
  # Right now normalization is based on the highest impressions, and how
  # this one stacks up. It should probably also take into consideration
  # How many gardens this thing is in.
  def calculate_popularity_score
    top_guides = Guide.all.sort_by { |g| g[:impressions_field].to_i || 0 }.reverse
    top_guide = top_guides.first
    normalized = impressions_field.to_f / top_guide.impressions_field

    write_attributes(popularity_score: normalized)
  end

  private

  # For each stage, find the overlapping needs,
  # and then calculate the percentage overlap of each need
  # ToDO this can be cleaned up, probably significantly
  # by externalizing the basic_need structure.
  def find_overlap_in(basic_needs)
    stages.each do |stage|
      basic_needs.each do |need|
        # This is bad structure
        if need[:name] == "Sun / Shade"
          build_overlap_and_total need, stage.light
        end
        if need[:name] == "Location"
          build_overlap_and_total need, stage.environment
        end
        if need[:name] == "Soil Type"
          build_overlap_and_total need, stage.soil
        end
      end
    end

    calculate_percents basic_needs
  end

  def build_overlap_and_total(need_hash, stage_req)
    if stage_req
      new_array = stage_req.select { |req| req == need_hash[:user] }
      need_hash[:overlap] += new_array
      need_hash[:total] = need_hash[:total] + stage_req
    end
  end

  def calculate_percents(basic_needs)
    basic_needs.each do |need|
      if need[:total] && !need[:total].empty?
        need[:percent] = need[:overlap].size.to_f / need[:total].size
      else
        need[:percent] = 0
      end
      # Compress the total array now that we don't need it's length
      need[:total].uniq!
    end
  end
end
