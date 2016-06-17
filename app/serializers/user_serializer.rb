class UserSerializer < BaseSerializer
  attribute :display_name
  attribute :email do
    if current_user == object
      object.admin
    end
  end
  attribute :admin do
    if current_user == object
      object.admin
    end
  end

  attribute :is_private do
    if current_user == object
      object.is_private
    end
  end

  attribute :help_list do
    if current_user == object
      object.help_list
    end
  end

  attribute :mailing_list do
    if current_user == object
      object.mailing_list
    end
  end

  has_many :gardens do
    if Pundit.policy(current_user, object).show?
      object.gardens
    end
  end

  has_many :guides do
    if Pundit.policy(current_user, object).show?
      object.guides
    end
  end

  has_many :favorited_guides do
    object.favorited_guides
  end

  has_one :user_setting do
    # TODO: Why is the policy on this being silly?
    # For now it is okay to show this data, but we probably
    # shouldn't.
    # if Pundit.policy(current_user, object).show?
      object.user_setting
    # end
  end

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
