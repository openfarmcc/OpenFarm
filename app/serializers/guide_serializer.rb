class GuideSerializer < BaseSerializer
  # attribute :crop_id
  # attribute :crop_name do
  #   object.crop.name
  # end
  has_one :crop
  has_one :user
  attribute :name
  attribute :overview
  attribute :featured_image do
    if object.featured_image
      {
        image_url: object.pictures[object.featured_image].attachment.url,
        thumbnail_url: object.pictures[object.featured_image].attachment.url(:small)
      }
    elsif object.pictures.count > 0
      {
        image_url: object.pictures.first.attachment.url,
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
end
