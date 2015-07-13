class UserSerializer < BaseSerializer
  attribute :display_name
  attribute :email do
    if current_user == object
      object.admin
    else
      nil
    end
  end
  attribute :admin do
    if current_user == object
      object.admin
    else
      nil
    end
  end

  attribute :is_private do
    if current_user == object
      object.is_private
    else
      nil
    end
  end

  attribute :help_list do
    if current_user == object
      object.help_list
    else
      nil
    end
  end

  attribute :mailing_list do
    if current_user == object
      object.mailing_list
    else
      nil
    end
  end

  has_many :gardens do
    if Pundit.policy(current_user, object).show?
      object.gardens
    else
      nil
    end
  end

  has_many :guides do
    if Pundit.policy(current_user, object).show?
      object.guides
    else
      nil
    end
  end

  has_one :user_setting do
    if Pundit.policy(current_user, object).show?
      object.user_setting
    else
      nil
    end
  end

  def filter(keys)
    if scope && scope.admin
      keys
    # Asks pundit to fetch the policy for the current_user (scope)
    # for the user being passed to it (object)
    elsif scope && Pundit.policy!(scope, object).show?
      keys - [:admin]
    else
      [:id, :display_name]
    end
  end
end
