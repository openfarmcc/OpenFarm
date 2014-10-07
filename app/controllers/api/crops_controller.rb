module Api
  class CropsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]
    def index
      if params[:query].present? && (params[:query].length > 2)
        q = params[:query]
        render json: { "crops" => Crop.search(q, fields: ["name^20", "common_names^10", "binomial_name^10", "description"], limit: 5) }
      else
        render json: { "crops" => [] }
      end
    end

    def show
      crop = Crop.find(params[:id])
      if crop
        render json: crop
      end
    end
  end
end
