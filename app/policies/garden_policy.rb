class GardenPolicy < ApplicationPolicy
  attr_reader :current_user, :garden

  def initialize(current_user, garden)
    @current_user = current_user
    @garden = garden
  end

  def show?
    if @current_user
      (not @garden.is_private?) || @current_user == @garden.user || @current_user.admin
    else
      not @garden.is_private?
    end
  end

  class Scope < Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @user.admin? ? @scope.all : @scope.or({ is_private: false }, { user: @user })
    end
  end
end
