class UserSerializer < BaseSerializer
  attribute :display_name
  attribute :email
  attribute :admin
  attribute :is_private
  attribute :help_list
  attribute :mailing_list

  has_many :gardens
  has_many :guides
  has_one :user_setting

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
