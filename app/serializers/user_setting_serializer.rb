class UserSettingSerializer < BaseSerializer
  attribute :location
  attribute :units
  attribute :years_experience

  attribute :favorite_crop do
    if object.favorite_crops.count > 0
      # TODO: THIS IS A HACK, this should just use the crop serializer
      crop_picture = nil
      thumbnail = nil
      if object.favorite_crops[0].pictures.count > 0
        crop_picture = object.favorite_crops[0].pictures[0].attachment.url
        thumbnail = object.favorite_crops[0].pictures[0].attachment.url(:small)
      end

      { id: object._id,
        image_url: crop_picture,
        thumbnail_url: thumbnail }
    end
  end

  attribute :pictures do
    object.pictures.map do |picture|
      { id: picture.id,
        image_url: picture.attachment.url,
        thumbnail_url: picture.attachment.url(:small),
        medium_url: picture.attachment.url(:medium),
        canopy_url: picture.attachment.url(:canopy)
      }
    end
  end
end
