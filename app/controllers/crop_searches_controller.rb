class CropSearchesController < ApplicationController

  def search
    #make sure the user entered some search text, if not flash an error
    if !crop_search_params[:searchtext].present?
      flash[:alert] = "Search can't be blank"
      return redirect_to root_path
    end
    #perform the search
    @results = Crop.full_text_search(crop_search_params[:searchtext],{:max_results => 100})
    #if the search came back with nothing, redirect to home and tell user
    if !@results.present?
      flash[:alert] = "No Crops found for: #{crop_search_params[:searchtext]}"
      return redirect_to root_path
    end
    render :show
  end

  private

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def crop_search_params
      params.require(:cropsearch).permit(:searchtext)
    end
end
