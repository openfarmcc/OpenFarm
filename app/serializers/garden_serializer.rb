class GardenSerializer < ApplicationSerializer
  attributes :_id, :location, :type, :average_sun, :soil_type, :ph,
             :growing_practices, :is_private, :user
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
  embeds_many :garden_crops  #,
            # embed: :ids,
            # key: :garden_crops,
            # embed_namespace: :links

  # has_many :garden_crops

  def filter(keys)
    if Pundit.policy(scope, object).show?
      keys - [:admin]
    else
      [:_id, :display_name]
    end
  end
end
