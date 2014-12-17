class CropsController < ApplicationController
  after_action :verify_authorized, except: [:index, :new, :show, :create]
  def index
    @crops = Crop.all
    redirect_to(controller: 'crop_searches', action: 'search')
  end

  def new
    @crop = Crop.new(name: params[:name])
  end

  def show
    @crop = Crop.find(params[:id])
    @guides = @crop.guides
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

  def edit
    @crop = Crop.find(params[:id])
    authorize @crop
  end

  def update
    @crop = Crop.find(params[:id])
    authorize @crop
    # TODO: Hacky hack is hacky.
    # Move the images in crop to be in images.
    # It's too nested if in crops.
    params[:images] = params[:crop][:images] ? [params[:crop][:images]] : []
    @outcome = Crops::UpdateCrop.run(params,
                                     crop: params[:crop],
                                     id: params[:id],
                                     user: current_user)
    if @outcome.success?
      @crop.reload
      redirect_to(action: 'show', id: @crop.id)
    else
      flash[:alert] = @outcome.errors.message_list
      @crop.reload
      render :edit
    end
  end

  private
  # TODO: This should be moved to a migration.
  def crops_params
    params.require(:crop).permit(:name, :binomial_name, :description,
              :sun_requirements, :sowing_method, :spread, :days_to_maturity,
              :row_spacing, :height)
  end
end
