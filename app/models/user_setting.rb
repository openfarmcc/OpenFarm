class UserSetting
  include Mongoid::Document
  belongs_to :user

  # TODO: These are being moved from user.rb, once
  # the migration is complete on the server,
  # delete them on user.rb ~@simonv3 16/03/2015

  field :location, type: String
  field :years_experience, type: Integer
  field :units, type: String
end
