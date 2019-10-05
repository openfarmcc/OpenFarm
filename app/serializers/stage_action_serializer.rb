# frozen_string_literal: true

class StageActionSerializer < BaseSerializer
  attribute :name
  attribute :overview
  attribute :time
  attribute :time_unit
  attribute :order
  attribute :id

  has_many :pictures

  attribute :pictures do
    object.pictures.map do |pic|
      {
        image_url: pic.attachment.url,
        medium_url: pic.attachment.url(:medium),
        thumbnail_url: pic.attachment.url(:small)
      }
    end
  end

  def self_link
    {
      'api': "/api/v1/stages/#{object.stage.id}/stage_actions/#{object.id}",
      'website': "/guides/#{object.stage.guide.id}/"
    }
  end
end
