class StageActionSerializer < BaseSerializer
  attribute :name
  attribute :overview
  attribute :time
  attribute :order

  attribute :pictures do
    object.pictures.map do |pic|
      { image_url: pic.attachment.url,
        medium_url: pic.attachment.url(:medium),
        thumbnail_url: pic.attachment.url(:small) }
    end
  end
end
