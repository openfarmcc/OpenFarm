class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :viewed_user

  def initialize(current_user, viewed_user)
    @current_user = current_user
    @viewed_user = viewed_user
  end

  def show?
    (not @viewed_user.is_private?) or
        @current_user == @viewed_user or
        @current_user.admin?
  end

  def update?
    @viewed_user == @current_user or @current_user.admin?
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.admin?
        @scope.all
      else
        @scope.where(is_private: false)
      end
    end
  end
end