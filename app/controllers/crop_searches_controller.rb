class CropSearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :search

  # TODO: eventually this search should also be searching guides
  def search
    # Singularize a word to only search singulars.
    # TODO : Write test case for this
    # TODO : Make this less of a hacky hotfix. Was getting production 500's.
    # Sorry
    if params[:cropsearch]
      search_word = params[:cropsearch][:q].to_s
    else
      search_word = params[:q].to_s
    end

    # Use search term to find crops
    @crops = Crop.full_text_search(search_word.singularize, max_results: 2)
    if @crops.empty?
      @crops = Crop.all.limit(2)
    end

    # Use the crop results to look-up guides
    crop_ids = @crops.pluck(:id)
    @guides = crop_ids.map! do |id|
      Guide.where(crop_id: id)
    end
    @guides.flatten!

    render :show
  end
end
