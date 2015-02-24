class Guide
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Slug
  searchkick

  is_impressionable counter_cache: true,
                    column_name: :impressions_field,
                    unique: :session_hash

  field :impressions_field, default: 0

  belongs_to :crop, counter_cache: true
  belongs_to :user
  has_many :stages

  embeds_one :time_span, cascade_callbacks: true, as: :timed

  field :name
  field :location
  field :overview
  field :practices, type: Array
  field :completeness_score, default: 0
  field :popularity_score, default: 0

  validates_presence_of :user, :crop, :name

  has_mongoid_attached_file :featured_image,
                            default_url: '/assets/baren_field.jpg'
  validates_attachment_size :featured_image, in: 1.byte..25.megabytes
  validates_attachment :featured_image,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  slug :name

  after_save :calculate_completeness_score
  # Maybe Popularity Score should be updated more frequently?
  after_save :calculate_popularity_score

  accepts_nested_attributes_for :time_span

  def owned_by?(current_user)
    !!(current_user && user == current_user)
  end

  def search_data
    as_json only: [:name, :overview, :crop_id]
  end

  def basic_needs
    if !user.gardens.empty?
      # We should probably store these in the DB
      basic_needs = [{ name: 'Sun / Shade',
                       slug: 'sun-shade',
                       overlap: [],
                       total: [],
                       percent: 0,
                       user: user.gardens.first.average_sun,
                       garden: user.gardens.first.name
                     }, {
                       name: 'Location',
                       slug: 'location',
                       overlap: [],
                       total: [],
                       percent: 0,
                       user: user.gardens.first.type,
                       garden: user.gardens.first.name
                     }, {
                       name: 'Soil Type',
                       slug: 'soil',
                       overlap: [],
                       total: [],
                       percent: 0,
                       user: user.gardens.first.soil_type,
                       garden: user.gardens.first.name
                     }, {
                       name: 'Practices',
                       slug: 'practices',
                       overlap: [],
                       total: [],
                       percent: 0,
                       user: user.gardens.first.growing_practices,
                       garden: user.gardens.first.name
                     }]

      # Still have to implement:
      # pH Range, Temperature, Water Use, Practices,
      # Time Commitment, Physical Ability, Time of Year

      find_overlap_in basic_needs
    end
  end

  def compatibility_score
    if !user.gardens.empty?
      count = 0
      sum = basic_needs.inject(0) do |memo, n|
        count += 1
        n[:percent] ? memo + n[:percent] : memo
      end
      (sum.to_f / count * 100).round
    end
  end

  def compatibility_label
    score = compatibility_score

    if score.nil?
      return ''
    elsif score > 75
      return 'high'
    elsif score > 50
      return 'medium'
    else
      return 'low'
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
    top_guides = Guide.all.sort_by { |g| g[:impressions_field] }.reverse
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
        if need[:name] == 'Sun / Shade'
          build_overlap_and_total need, stage.light
        end
        if need[:name] == 'Location'
          build_overlap_and_total need, stage.environment
        end
        if need[:name] == 'Soil Type'
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
