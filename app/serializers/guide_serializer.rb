class GuideSerializer < ApplicationSerializer
  attributes :_id, :crop_id, :user_id, # :stages,
             :name, :overview, :featured_image, :location,
             :practices, :compatibility_score, :basic_needs

  has_many :stages

  def featured_image
    object.featured_image.url
  end

  def compatibility_score
    object.compatibility_score
  end

  def basic_needs
    object.basic_needs
  end
end
