class GuideSerializer < ApplicationSerializer
  attributes :_id, :crop_id, :user_id, :stages, :requirements,
             :name, :overview
end
