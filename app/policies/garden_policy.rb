class GardenPolicy < ApplicationPolicy
  attr_reader :current_user, :garden

  def initialize(current_user, garden)
    @current_user = current_user
    @garden = garden
  end

  def show?
    if @current_user
      (!@garden.is_private?) ||
          @current_user == @garden.user ||
          @current_user.admin
    else
      !@garden.is_private?
    end
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
