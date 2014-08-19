class CropSearchesController < ApplicationController

  def search
    @results = Crop.full_text_search(params[:q],{:max_results => 100})
    #if the search came back with nothing, redirect to home and tell user
    if @results.empty?
      @results = Crop.all.limit(100)
    end
    render :show
  end
end
