class GardenSerializer < BaseSerializer
  attribute :name
  attribute :description
  attribute :location
  attribute :type
  attribute :average_sun
  attribute :soil_type
  attribute :ph
  attribute :growing_practices
  attribute :is_private
  attribute :user
  # inserting the 'has_one :user' means that a user gets inserted,
  # which has as result that this garden gets inserted, recursive etc.
  # 'stack level too deep', so. Maybe we need a 'ShortUserSerializer'? ToDo
  # has_one :user

  # TODO. I tried really hard to make this conform to JSONApi,
  # but I'm getting an error saying that the hash can not be concattenated
  # Might have to wait until AMS 0.10.0, which looks like it will
  # conform to JSONApi out of the box.
  # There might be a solution here:
  # https://github.com/rails-api/active_model_serializers/issues/646
  # embeds_many :garden_crops # ,
  # embed: :ids,
  # key: :garden_crops,
  # embed_namespace: :links

  has_many :garden_crops
  has_many :pictures
end
