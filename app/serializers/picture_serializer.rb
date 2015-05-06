class PictureSerializer < ApplicationSerializer
  attributes :id, :image_url, :thumbnail_url

  def image_url
    object.attachment.url
  end

  def thumbnail_url
    object.attachment.url(:medium)
  end
end
