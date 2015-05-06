class UserSettingSerializer < ApplicationSerializer
  attributes :_id, :location, :units, :years_experience, :favorite_crop

  has_one :picture, serializer: PictureSerializer

  def favorite_crop
    if object.favorite_crops.count > 0
      # TODO: THIS IS A HACK, this should just use the crop serializer
      crop_picture = nil
      thumbnail = nil
      if object.favorite_crops[0].pictures.count > 0
        crop_picture = object.favorite_crops[0].pictures[0].attachment.url
        thumbnail = object.favorite_crops[0].pictures[0].attachment.url(:small)
      end

      {
          id: object._id,
          image_url: crop_picture,
          thumbnail_url: thumbnail
      }
    else
      nil
    end
  end
end
