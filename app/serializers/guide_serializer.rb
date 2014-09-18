class GuideSerializer < ApplicationSerializer
  attributes :_id, :crop_id, :user_id, :stages, :requirements,
             :name, :overview, :featured_image

  def featured_image
    img = object.featured_image
    if img.blank?
      # HACKY HACK IS SO HACKY.
      'http://openfarm.cc/img/page.png'
    else
      img.url
    end
  end
end
