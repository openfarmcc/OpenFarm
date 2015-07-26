class Api::V1::GardenCropsController < Api::V1::BaseController
  def index
    garden = Garden.find(params[:garden_id])
    # Visible based on the policy of the garden
    if Pundit.policy(current_user, garden).show?
      garden_crops = garden.garden_crops
      render json: serialize_models(garden_crops)
    else
      raise OpenfarmErrors::NotAuthorized
    end
  rescue Mongoid::Errors::DocumentNotFound
    render json: 'Garden not found', status: 404
  end

  def create
    # According to JSON-API Params must be structured like this:
    # {
    #  'data': {
    #     'type': 'garden-crops',
    #     'attributes': {},
    # }
    @outcome = GardenCrops::CreateGardenCrop.run(
      params[:data],
      garden_id: params[:garden_id],
      user: current_user
    )
    respond_with_mutation(:created)
  end

  def show
    garden = Garden.find(params[:garden_id])
    # Visible based on the policy of the garden
    if Pundit.policy(current_user, garden).show?
      garden_crop = garden.garden_crops.find(params[:id])
      render json: serialize_model(garden_crop)
    else
      raise OpenfarmErrors::NotAuthorized
    end
  rescue Mongoid::Errors::DocumentNotFound
    render json: 'Garden not found', status: 404
  end

  def update
    # According to JSON-API params must be structured like this:
    # {
    #  'data': {
    #     'type': 'garden-crops',
    #     'id': <id>,
    #     'attributes': {},
    # }
    garden_crop = Garden.find(params[:garden_id]).
                  garden_crops.find(params[:id])
    @outcome = GardenCrops::UpdateGardenCrop.run(params[:data],
                                                 user: current_user,
                                                 garden_crop: garden_crop)
    respond_with_mutation(:ok)
  end

  def destroy
    @outcome = GardenCrops::DestroyGardenCrop.run(params,
                                                  user: current_user)
    respond_with_mutation(:no_content)
  end
end
