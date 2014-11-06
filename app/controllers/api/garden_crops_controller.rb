module Api
  class GardenCropsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index]

    def index
      garden_crops = Garden.find(params[:garden_id]).garden_crops
      render json: garden_crops
    end

    def create
      @outcome = GardenCrops::CreateGardenCrop.run(
        params,
        user: current_user
      )
      respond_with_mutation(:created)
    end

    def show
      garden_crop = Garden.find(params[:garden_id]).
          garden_crops.find(params[:id])
      render json: garden_crop
    end

    def update
      garden_crop = Garden.find(params[:garden_id]).
          garden_crops.find(params[:id])
      @outcome = GardenCrops::UpdateGardenCrop.run(params,
                                                   user: current_user,
                                                   garden_crop: garden_crop)
      respond_with_mutation(:ok)
    end

    def destroy
      @outcome = GardenCrops::DestroyGardenCrop.run(params,
                                                    user: current_user)
      if @outcome.success?
        render nothing: true, status: :no_content
      else
        render json: @outcome.errors.message, status: :unprocessable_entity
      end
    end
  end
end
