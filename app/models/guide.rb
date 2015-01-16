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
  # has_many :requirements

  field :name
  field :location
  field :overview
  field :practices, type: Array

  validates_presence_of :user, :crop, :name

  has_mongoid_attached_file :featured_image,
                            default_url: '/assets/leaf-grey.png'
  validates_attachment_size :featured_image, in: 1.byte..2.megabytes
  validates_attachment :featured_image,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  def owned_by?(current_user)
    !!(current_user && user == current_user)
  end

  def search_data
    as_json only: [:name, :overview, :crop_id]
  end

  def basic_needs
    # User needs to have a garden to have basic needs

    overlap_l = []
    overlap_e = []
    overlap_s = []
    total_l = []
    total_e = []
    total_s = []

    if !user.gardens.empty?
      user_environment = user.gardens.first.type
      user_light = user.gardens.first.average_sun
      user_ph = user.gardens.first.ph
      user_soil = user.gardens.first.soil_type

      # TODO: We are duplicating code in the JS
      # controller here. Clean that one up.

      puts stages.to_json
      stages.each do |s|
        if s.light
          overlap_l = overlap_l + s.light.select { |l| l == user_light }
          total_l = total_l + s.light
        end

        if s.environment
          new_array = s.environment.select { |e| e == user_environment }
          overlap_e = overlap_e + new_array
          total_e = total_e + s.environment
        end

        if s.soil
          overlap_s = overlap_s + s.soil.select { |soil| soil == user_soil }
          total_s = total_s + s.soil
        end
      end
    end

    # We should probably store these in the backend

    [
      {
        name: 'Sun / Shade',
        overlap: overlap_l,
        have: user_light,
        need: total_l,
        percent: !total_l.empty? ? overlap_l.size.to_f / total_l.size : 0
      }, {
        name: 'pH Range',
        have: user_ph
      }, {
        name: 'Temperature'
      }, {
        name: 'Soil Type',
        need: total_s,
        have: user_soil,
        overlap: overlap_s,
        percent: !total_s.empty? ? overlap_s.size.to_f / total_s.size : 0
      }, {
        name: 'Water Use'
      }, {
        name: 'Location',
        overlap: overlap_e,
        need: total_e,
        have: user_environment,
        percent: !total_e.empty? ? overlap_e.size.to_f / total_e.size : 0
      }, {
        name: 'Practices',
        value: practices
      }, {
        name: 'Time Commitment'
      }, {
        name: 'Physical Ability'
      }, {
        name: 'Time of Year'
      }
    ]
  end

  def compatibility_score
    count = 0
    sum = basic_needs.inject(0) do |memo, n|
      count += 1
      n[:percent] ? memo + n[:percent] : memo
    end
    sum.to_f / count
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

  slug :name
end
