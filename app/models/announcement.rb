class Announcement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message
  field :starts_at, type: DateTime
  field :ends_at, type: DateTime
  field :is_permanent, type: Mongoid::Boolean, default: false

  scope :active, where(:starts_at.lte => Time.now,
                       :ends_at.gte => Time.now)

  scope :permanent, where(is_permanent: true)

  scope :showing, -> { any_of([permanent.selector, active.selector]) }

  def self.current(hide_time)
    if hide_time.nil?
      showing
    else
      showing.union.where(:updated_at.gte => hide_time)
    end
  end
end
