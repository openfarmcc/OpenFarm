class Announcement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message
  field :starts_at, type: DateTime
  field :ends_at, type: DateTime

  def self.current(hide_time)
    # puts DateTime.current()
    puts hide_time
    # with_scope :where => { :starts_at.lte => DateTime.now, :ends_at.gte => DateTime.now }
    if hide_time.nil?
      where(:starts_at.lte => Time.now,
            :ends_at.gte => Time.now)
    else
      where(:starts_at.lte => Time.now,
            :ends_at.gte => Time.now,
            :updated_at.gte => hide_time)
    end
  end
end
