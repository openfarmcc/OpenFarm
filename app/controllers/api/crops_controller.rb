# OUT OF DATE, Don't use. 08/07/2015
module Api
  class CropsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]
    def index
      if params[:query].present? && (params[:query].length > 2)
        q = params[:query]
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
        render json: {crops: crops}
      else
        render json: {crops: []}
      end
    end

    def show
      crop = Crop.find(params[:id])
      if crop
        render json: crop
      end
    end

    def update
      @outcome = Crops::UpdateCrop.run(params,
                                       user: current_user,
                                       id: params[:id])
      respond_with_mutation(:ok)
    end
  end
end
