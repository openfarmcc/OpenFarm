module Api
  class CropsController < Api::Controller
    def index
      if params[:query].present? && (params[:query].length > 3)
        render json: Crop.full_text_search(params[:query]).limit(5)
      else
        render json: []
      end
    end
  end
end
