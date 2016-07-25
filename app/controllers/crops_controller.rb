class CropsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]
  def index
    @crops = Crop.all
    redirect_to(controller: 'crop_searches', action: 'search')
  end

  def new
    @crop = Crop.new(name: params[:name])
    authorize @crop
  end

  def show
    @crop = Crop.find(params[:id])
    # disabling impressionist for now because it's a likely
    # culprit for slowing everything really down on the server.
    # ~ Simon 07/2016
    # impressionist(@crop, unique: [:session_hash])
    @guides = GuideSearch.search.for_crops(@crop).with_user(current_user)
  end

  def create
    @crop = Crop.new(crops_params)
    authorize @crop
    if @crop.save && params[:crop][:source] == 'guide'
      redirect_to(controller: 'guides', action: 'new',
                  crop_id: @crop.id)
    elsif @crop.save
      redirect_to(controller: 'crops', action: 'show',
                  id: @crop.id)
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
    attributes = params[:attributes]
    params[:images] = attributes[:images] ? [attributes[:images]] : []
    @outcome = Crops::UpdateCrop.run(params,
                                     attributes: attributes,
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
