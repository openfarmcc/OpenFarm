class CropSearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :search

  def search
    query = params[:q].to_s
    @crops = Crop.search(query,
                         limit: 25,
                         fields: ['name^20',
                                  'common_names^10',
                                  'binomial_name^10',
                                  'description'])
    if query.empty?
      @crops = Crop.search('*', limit: 25)
    end

    # Use the crop results to look-up guides
    crop_ids = @crops.map { |crop| crop.id }
    @guides = Guide.search('*', where: {crop_id: crop_ids})

    render :show
  end
end
