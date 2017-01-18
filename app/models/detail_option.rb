# This is a catch-all class to store information
# on guides.
#
# Category is something like "environment", "location", "practices",
# "soil", "light"

class DetailOption
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :help, type: String
  field :category, type: String
end
