module Api
  class CropsController < Api::Controller
    skip_before_action :authenticate_user!, only: :index
    def index
      if params[:query].present? && (params[:query].length > 2)
        q = params[:query].singularize
        render json: Crop.full_text_search(q).limit(5)
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
