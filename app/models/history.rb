class History
  # include Mongoid::Document
  include Mongoid::History::Trackable
  # include Mongoid::Attributes::Dynamic
end
