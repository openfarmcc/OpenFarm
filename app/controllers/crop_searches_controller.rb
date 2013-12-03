class CropSearchesController < ApplicationController

  def search
    @results = Crop.full_text_search(crop_search_params)
    render :show
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def crop_search_params
      params.permit(:q)
    end
end
