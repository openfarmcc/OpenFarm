class PictureSerializer < ApplicationSerializer
  attributes :id, :image_url, :thumbnail_url

  def image_url
    puts object.to_json
    object.attachment.url
  end

  def thumbnail_url
    object.attachment.url(:small)
  end
end
