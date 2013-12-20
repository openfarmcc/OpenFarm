class CropsController < ApplicationController
  def new
    @crop = Crop.new
  end
  
  def show
    @crop = Crop.find(params[:id])
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