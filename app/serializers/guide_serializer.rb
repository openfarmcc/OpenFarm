class GuideSerializer < BaseSerializer
  # attribute :crop_id
  # attribute :crop_name do
  #   object.crop.name
  # end
  has_one :crop
  has_one :user
  attribute :draft
  attribute :name
  attribute :overview
  attribute :featured_image do
    if object.featured_image
      {
        canopy_url: object.pictures[object.featured_image].attachment.url(:canopy),
        image_url: object.pictures[object.featured_image].attachment.url,
        medium_url: object.pictures[object.featured_image].attachment.url(:medium),
        thumbnail_url: object.pictures[object.featured_image].attachment.url(:small)
      }
    elsif object.pictures.count > 0
      {
        canopy_url: object.pictures.first.attachment.url(:canopy),
        image_url: object.pictures.first.attachment.url,
        medium_url: object.pictures.first.attachment.url(:medium),
        thumbnail_url: object.pictures.first.attachment.url(:small)
      }
    end
  end
  attribute :location
  attribute :practices
  attribute :compatibility_score do
    object.compatibility_score(current_user)
  end
  attribute :basic_needs do
    object.basic_needs(current_user)
  end
  attribute :completeness_score
  attribute :popularity_score

  has_many :stages
  has_one :time_span

  has_many :pictures, serializer: PictureSerializer
end
