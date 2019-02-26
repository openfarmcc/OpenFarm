class Api::V1::CropsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index, :show]

  def index
    if raw_params[:filter].present? && (raw_params[:filter].length > 2)
      q = raw_params[:filter]
      crops = Crop.search(q,
                          limit: 25,
                          operator: "or", # partial: true,
                          misspellings: { distance: 1 },
                          fields: ["name^20",
                                   "common_names^10",
                                   "binomial_name^10",
                                   "description"],
                          boost_by: [:guides_count])
      render json: serialize_models(crops, include: ["pictures"])
    else
      render json: serialize_models(Crop.none)
    end
  end

  def show
    crop = Crop.find(raw_params[:id])
    render json: serialize_model(crop, include: ["pictures", "companions"])
  end

  def create
    @outcome = Crops::CreateCrop.run(raw_params[:data],
                                     user: current_user)
    respond_with_mutation(:ok, include: ["pictures"])
  end

  def update
    # According to JSON-API Params must be structured like this:
    # {
    #   'data': {
    #     'type': 'crops',
    #     'id': '<id>',
    #     'attributes': {
    #     },
    #   }
    # }
    @outcome = Crops::UpdateCrop.run(raw_params[:data],
                                     user: current_user,
                                     id: raw_params[:id])
    respond_with_mutation(:ok, include: ["pictures"])
  end
end
