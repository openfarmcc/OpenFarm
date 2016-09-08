class Api::V1::CropsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index, :show]

  def index
    if params[:filter].present? && (params[:filter].length > 2)
      q = params[:filter]
      crops = Crop.search(q,
                          limit: 25,
                          partial: true,
                          misspellings: { distance: 1 },
                          fields: ['name^20',
                                   'common_names^10',
                                   'binomial_name^10',
                                   'description'],
                          boost_by: [:guides_count]
                         )
      render json: serialize_models(crops, include: ['pictures'])
    else
      render json: serialize_models(Crop.none)
    end
  end

  def show
    crop = Crop.find(params[:id])
    render json: serialize_model(crop, include: ['pictures'])
  end

  def create
    @outcome = Crops::CreateCrop.run(params[:data],
                                     user: current_user)
    respond_with_mutation(:ok, include: ['pictures'])
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
    @outcome = Crops::UpdateCrop.run(params[:data],
                                     user: current_user,
                                     id: params[:id])
    respond_with_mutation(:ok, include: ['pictures'])
  end
  def tag
    Crop.find(params[:id]).update_attributes(tags: params[:tags])
  end
end
