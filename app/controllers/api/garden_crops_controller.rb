module Api
  class GardenCropsController < Api::Controller
    def index
      garden = Garden.find(params[:garden_id])
      # Visible based on the policy of the garden
      if Pundit.policy(current_user, garden).show?
        garden_crops = garden.garden_crops
        render json: { garden_crops: garden_crops }
      else
        raise OpenfarmErrors::NotAuthorized
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: 'Garden not found', status: 404
    end

    def create
      @outcome = GardenCrops::CreateGardenCrop.run(
        params,
        user: current_user
      )
      respond_with_mutation(:created)
    end

    def show
      garden = Garden.find(params[:garden_id])
      # Visible based on the policy of the garden
      if Pundit.policy(current_user, garden).show?
        garden_crop = garden.garden_crops.find(params[:id])
        render json: { garden_crop: garden_crop }
      else
        raise OpenfarmErrors::NotAuthorized
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: 'Garden not found', status: 404
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
      respond_with_mutation(:no_content)
      # if @outcome.success?
      #   render nothing: true, status: :no_content
      # else
      #   render json: @outcome.errors.message, status: :unprocessable_entity
      # end
    end
  end
end
