class GuideSerializer < ApplicationSerializer
  attributes :_id, :crop_id, :crop_name, :user_id, :name, :overview,
             :featured_image, :location, :practices, :compatibility_score,
             :basic_needs, :completeness_score, :popularity_score

  has_many :stages
  has_one :time_span

  def featured_image
    object.featured_image.url
  end

  def compatibility_score
    object.compatibility_score(current_user)
  end

  def basic_needs
    object.basic_needs(current_user)
  end

  def crop_name
    object.crop.name
  end
  
end
