class CropSearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :search

  # TODO: eventually this search should also be searching guides
  def search
    query = (params[:cropsearch] && params[:cropsearch][:q]).to_s.singularize
    @crops = Crop.full_text_search(query, max_results: 2)
    if @crops.empty?
      @crops = Crop.all.desc('_id').limit(2)
    end

    # Use the crop results to look-up guides
    # TODO: Refactor this query.
    crop_ids = @crops.pluck(:id)
    @guides = crop_ids.map! do |id|
      Guide.where(crop_id: id)
    end
    @guides.flatten!

    render :show
  end
end
