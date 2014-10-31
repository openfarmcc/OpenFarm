class GardenPolicy < ApplicationPolicy
  attr_reader :current_user, :garden

  def initialize(current_user, garden)
    @current_user = current_user
    @garden = garden
  end

  def show?
    (not @garden.is_private?) or
        @current_user == @garden.user or
        @current_user.admin?
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
        @scope.or(
          { is_private: false },
          { user: @user }
        )
      end
    end
  end
end