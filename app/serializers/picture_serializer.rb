class PictureSerializer < BaseSerializer
  attribute :id
  attribute :image_url do
    object.attachment.url
  end
  attribute :thumbnail_url do
    object.attachment.url(:medium)
  end
  attribute :medium_url do
    object.attachment.url(:medium)
  end

  # It doesn't make sense to reference pictures
  # because they're nested within the respective object,
  # and don't exist outside of them. They're also
  # not stored by us, so the URL doesn't correspond to the
  # data.
  def self_link
    nil
  end
end
