class GuidesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]

  def index
    @guides = Guide.all
  end

  def show
    @guide = Guide.find(params[:id])
  end

  def new
    @guide = Guide.new
  end

  def edit
    @guide = Guide.find(params[:id])

    if not @guide.user.id == current_user.id
      redirect_to @guide
    end
  end
end
