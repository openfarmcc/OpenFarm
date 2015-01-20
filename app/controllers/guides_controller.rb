class GuidesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @guides = Guide.where({user: current_user })
  end

  def show
    @guide = Guide.find(params[:id])
    impressionist(@guide, '', unique: [:session_hash])
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
