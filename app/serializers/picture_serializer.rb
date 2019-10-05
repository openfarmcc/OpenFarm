# frozen_string_literal: true

class PictureSerializer < BaseSerializer
  attribute :id
  attribute :photographic_id do
    object.photographic._id
  end

  attribute :image_url do
    object.attachment.url
  end
  attribute :small_url do
    object.attachment.url(:small)
  end
  attribute :thumbnail_url do
    object.attachment.url(:small)
  end
  attribute :medium_url do
    object.attachment.url(:medium)
  end
  attribute :large_url do
    object.attachment.url(:large)
  end
  attribute :canopy_url do
    object.attachment.url(:canopy)
  end

  # It doesn't make sense to reference pictures
  # because they're nested within the respective object,
  # and don't exist outside of them. They're also
  # not stored by us, so the URL doesn't correspond to the
  # data.
  def self_link
    nil
  end

  def type
    parent_name = object.photographic.class.name.demodulize.tableize.dasherize
    object_name = object.class.name.demodulize.tableize.dasherize
    "#{parent_name}-#{object_name}"
  end
end
