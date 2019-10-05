# frozen_string_literal: true

class CropPolicy < ApplicationPolicy
  attr_reader :current_user, :crop

  def initialize(current_user, crop)
    @current_user = current_user
    @crop = crop
  end

  def new?
    @current_user ? true : false
  end

  def create?
    @current_user ? true : false
  end

  def update?
    @current_user ? true : false
  end

  # We're making this admin-only for now
  # Cause we need to figure out the process
  # For this. There's a lot of UI that needs
  # To be
  def edit?
    @current_user ? true : false
  end

  # class Scope < Scope
  #   attr_reader :user, :scope
  #   def initialize(user, scope)
  #     @user = user
  #     @scope = scope
  #   end

  #   def resolve
  #     @scope.all
  #   end
  # end
end
