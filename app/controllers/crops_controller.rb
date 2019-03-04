class CropsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]

  def index
    @crops = Crop.all
    redirect_to(controller: "crop_searches", action: "search")
  end

  def new
    @crop = Crop.new(name: raw_params[:name])
    authorize @crop
  end

  def show
    @crop = Crop.find(raw_params[:id])
    # If the server ever starts crashing because things are taking a _long_
    # time to calculate, it's probably because our impressions table is just too
    # darned large. This will start being a problem at around 10k impressions.
    # ~ Simon 07/2016
    impressionist(@crop, unique: [:session_hash])
    unsorted_guides = @crop
      .guides
      .order(impressionist_count: :asc)
      .limit(10)
      .to_a || []
    @guides = Guide.sorted_for_user(unsorted_guides, current_user)
  end

  def create
    @crop = Crop.new(crops_params)
    authorize @crop
    if @crop.save && raw_params[:crop][:source] == "guide"
      redirect_to(controller: "guides", action: "new",
                  crop_id: @crop.id)
    elsif @crop.save
      redirect_to(controller: "crops", action: "show",
                  id: @crop.id)
    else
      render :new
    end
  end

  def edit
    @crop = Crop.find(raw_params[:id])
    authorize @crop
  end

  def update
    @crop = Crop.find(raw_params[:id])
    authorize @crop
    # TODO: Hacky hack is hacky.
    # Move the images in crop to be in images.
    # It's too nested if in crops.
    attributes = raw_params[:attributes]
    raw_params[:images] = attributes[:images] ? [attributes[:images]] : []
    @outcome = Crops::UpdateCrop.run(raw_params,
                                     attributes: attributes,
                                     id: raw_params[:id],
                                     user: current_user)
    if @outcome.success?
      @crop.reload
      redirect_to(action: "show", id: @crop.id)
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
