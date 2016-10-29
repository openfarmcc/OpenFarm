class TimeSpan
  include Mongoid::Document

  # This is a hell of a class.

  # Basically we came to the conclusion that we don't want
  # to dictate how people store their dates. Someone might plant
  # something on the second week of spring based on their hemisphere.
  # and we should just present it like that to the user.
  # we don't want to dictate dates.
  # What we have below is what we think most things will conform to,
  # but it's very possible some things will be missed.
  # All fields are optional.

  embedded_in :timed, inverse_of: :time_span, polymorphic: true

  field :start_event
  # format is the ruby standard date format:
  # http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/DateTime.html#strftime-method
  field :start_event_format
  field :start_offset_units
  field :start_offset_amount
  field :end_event
  field :end_event_format
  field :end_offset_units
  field :end_offset
  field :length_units
  field :length

  # This is a way of sanely keeping a check on what functionality
  # we support at the moment. Weeks is what is supported for now.
  validates :length_units, inclusion: { in: ['weeks'] }
end
