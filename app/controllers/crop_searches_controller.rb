class CropSearchesController < ApplicationController

  def search
    # Singularize a word to only search singulars.
    search_word = params[:cropsearch][:q].singularize
    @results = Crop.full_text_search(search_word, 
      :max_results => 100)
    if @results.empty?
      @results = Crop.all.limit(100)
    end
    render :show
  end
end
