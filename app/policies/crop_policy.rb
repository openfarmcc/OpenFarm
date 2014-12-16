class CropPolicy < ApplicationPolicy
  attr_reader :current_user, :crop

  def initialize(current_user, crop)
    @current_user = current_user
    @crop = crop
  end

  def update?
    if @current_user
      @current_user.admin
    else
      false
    end
  end

  def edit?
    if @current_user
      @current_user.admin
    else
      false
    end
  end

  class Scope < Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # def resolve
    #   if @user.admin?
    #     @scope.all
    #   else
    #     @scope.or(
    #       { is_private: false },
    #       { user: @user }
    #     )
    #   end
    # end
  end
end
