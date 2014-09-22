class CropsController < ApplicationController

  def index
    @crops = Crop.all
    redirect_to(controller: 'crop_searches', action: 'search')
  end

  def new
    @crop = Crop.new(name: params[:name])
  end
  
  def show
    @crop = Crop.find(params[:id])
  end
  
  def create
    @crop = Crop.new(crops_params)
    if @crop.save
      redirect_to(controller: 'guides', action: 'new',
                  crop_id: @crop.id)
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