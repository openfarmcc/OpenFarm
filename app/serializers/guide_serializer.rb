class GuideSerializer < ApplicationSerializer
  attributes :_id, :crop_id, :user_id, # :stages,
             :name, :overview, :featured_image, :location,
             :practices

  has_many :stages

  def featured_image
    object.featured_image.url
  end
end
