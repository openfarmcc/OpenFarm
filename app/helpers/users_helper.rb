module UsersHelper
  def list_gardens_on_show?
    has_non_default_garden?(@user) || authorized_for?(@user)
  end

  def has_non_default_garden?(user)
    user.gardens.each { |garden| return true unless garden.user_default?}

    false
  end

  def authorized_for?(user)
    user == current_user && current_user.confirmed?
  end
end
