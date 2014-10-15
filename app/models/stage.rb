class Stage
  include Mongoid::Document
  # https://github.com/mauriciozaffari/mongoid_search

  belongs_to :guide

  field :name, type: String
  field :days_start, type: Integer
  field :days_end, type: Integer
  field :instructions, type: String

end
