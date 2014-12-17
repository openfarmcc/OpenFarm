class PictureSerializer < ApplicationSerializer
  attributes :image_url, :thumbnail_url

  def image_url
    object.attachment.url
  end

  def thumbnail_url
    object.attachment.url(:small)
  end
end
