class CropsController < ApplicationController

  def index
    @crops = Crop.all
    respond_to do |format|
      # WOA 
      format.html # show.html.erb
      format.json { render json: @crops }

    end
  end

  def new
    @crop = Crop.new
  end
  
  def show
    @crop = Crop.find(params[:id])

    respond_to do |format|
      # WOA 
      format.html # show.html.erb
      format.json { render json: @crop }

    end
  end
  
  def create
    @crop = Crop.new(crops_params)
    if @crop.save
      redirect_to @crop
    else
      render :new
    end
  end
  
  private
  def crops_params
    params.require(:crop).permit(:name, :binomial_name, :description, 
              :sun_requirements, :sowing_method, :spread, :days_to_maturity,
              :row_spacing, :height)
  end
end