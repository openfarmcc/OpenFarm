class CropSearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :search

  # TODO: eventually this search should also be searching guides
  def search
    query = (params[:cropsearch] && params[:cropsearch][:q]).to_s
    @crops = Crop.search(query, fields: ['name^20', 'common_names^10', 'binomial_name^10', 'description'], limit: 25)
    if @crops.empty?
      @crops = Crop.search('*', limit: 25)
    end

    # Use the crop results to look-up guides
    crop_ids = @crops.map { |crop| crop.id }
    @guides = Guide.search('*', where: {crop_id: crop_ids})

    render :show
  end
end
