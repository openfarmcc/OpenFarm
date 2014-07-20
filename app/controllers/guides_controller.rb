class GuidesController < ApplicationController
  def new
    @guide = Guide.new
  end
  
  def index
    @guides = Guide.all
  end

  def show
    @guide = Guide.find(params[:id])
  end
  
  def create
    @guide = Guide.new(guides_params)
    if @guide.save
      redirect_to @guide
    else
      render :new
    end
  end
  
  private
  def guides_params
    params.require(:guide).permit(:name, :user)
  end
end