class TimeSpan
  include Mongoid::Document

  embedded_in :timed, inverse_of: :time_span, polymorphic: true

  field :start_event
  field :start_offset_units
  field :start_offset_amount
  field :end_event
  field :end_offset_units
  field :end_offset
  field :length_units
  field :length
end
