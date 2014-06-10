class CropSearchesController < ApplicationController

  def search
    if (crop_search_params[:q].empty?)
      redirect_to root_path
    else
      @results = Crop.full_text_search(crop_search_params,{:max_results => 100})
      render :show
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def crop_search_params
      params.permit(:q)
    end
end
