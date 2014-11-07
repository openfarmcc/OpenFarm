class UserSerializer < ApplicationSerializer
  attributes :_id, :display_name, :email, :admin,
             :location, :years_experience, :units, :is_private

  has_many :gardens  # , embed: :ids, key: :gardens, embed_namespace: :links
  has_many :guides  # , embed: :ids, key: :guides, embed_namespace: :links

  def filter(keys)
    if scope && scope.admin
      keys
    # Asks pundit to fetch the policy for the current_user (scope)
    # for the user being passed to it (object)
    elsif scope && Pundit.policy!(scope, object).show?
      keys - [:admin]
    else
      [:_id, :display_name]
    end
  end
end
