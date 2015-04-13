class UserSettingSerializer < ApplicationSerializer
  attributes :_id, :location, :units, :years_experience

  has_one :favorite_crop
end
