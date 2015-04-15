class UserSettingSerializer < ApplicationSerializer
  attributes :_id, :location, :units, :years_experience, :favorite_crop

  has_one :picture, serializer: PictureSerializer

  def favorite_crop
    if object.favorite_crops.count > 0
      # TODO: THIS IS A HACK, this should just use the crop serializer
      { favorite_crop: {
          image_url: object.favorite_crops[0].pictures[0].attachment.url,
          thumbnail_url: object.favorite_crops[0].pictures[0].attachment.url(:small)
      } }
    else
      nil
    end
  end
end
