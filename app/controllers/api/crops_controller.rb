module Api
  class CropsController < Api::Controller
    skip_before_action :authenticate_user!, only: :index
    def index
      if params[:query].present? && (params[:query].length > 2)
        render json: Crop.full_text_search(params[:query]).limit(5)
      else
        render json: {"crops"=>[]}
      end
    end
  end
end
