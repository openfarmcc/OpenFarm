class PictureSerializer < ApplicationSerializer
  attributes :image_url

  def image_url
    object.attachment.url
  end
end
