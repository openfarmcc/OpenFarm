class CropSearchesController < ApplicationController

  def search
    @results = Crop.full_text_search(params[:cropsearch][:q],{:max_results => 100})
    if @results.empty?
      @results = Crop.all.limit(100)
    end
    render :show
  end
end
