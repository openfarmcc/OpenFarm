class UserSettingSerializer < ApplicationSerializer
  attributes :_id, :location, :units, :years_experience, :favorite_crop

  def favorite_crop
    # TODO: THIS IS A HACK, this should just use the crop serializer
    {
      image_url: object.favorite_crops[0].pictures[0].attachment.url,
      thumbnail_url: object.favorite_crops[0].pictures[0].attachment.url(:small)
    }
  end
end
