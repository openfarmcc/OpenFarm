class UserSetting
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :user

  # TODO: These are being moved from user.rb, once
  # the migration is complete on the server,
  # delete them on user.rb ~@simonv3 16/03/2015

  field :location, type: String
  field :years_experience, type: Integer
  field :units, type: String

  # The below are new and don't have to be migrated
  # has_one :crop, as: :favorite_crop

  embeds_one :picture, as: :photographic
end
