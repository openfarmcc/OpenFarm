class UserSerializer < BaseSerializer
  attribute :display_name
  attribute :email do
    object.admin if current_user == object
  end
  attribute :admin do
    object.admin if current_user == object
  end

  attribute :is_private do
    object.is_private if current_user == object
  end

  attribute :help_list do
    object.help_list if current_user == object
  end

  attribute :mailing_list do
    object.mailing_list if current_user == object
  end

  has_many :gardens do
    object.gardens if Pundit.policy(current_user, object).show?
  end

  has_many :guides do
    object.guides if Pundit.policy(current_user, object).show?
  end

  has_many :favorited_guides do
    object.favorited_guides
  end

  has_one :user_setting, serializer: UserSettingSerializer

  # This was from before the JSON-API refactor, I'm not sure that
  # this is still necessary.
  # def filter(keys)
  #   if scope && scope.admin
  #     keys
  #   # Asks pundit to fetch the policy for the current_user (scope)
  #   # for the user being passed to it (object)
  #   elsif scope && Pundit.policy!(scope, object).show?
  #     keys - [:admin]
  #   else
  #     [:id, :display_name]
  #   end
  # end
end
