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
    if @crops.empty?
      @crops = Crop.search('*', limit: 25)
    end

    # Use the crop results to look-up guides
    crop_ids = @crops.map { |crop| crop.id }
    @guides = Guide.search('*', where: {crop_id: crop_ids})

    # For testing compatibility scores (REMOVE FOR PRODUCTION)
    # @guides.each do |g|
    #   g[:compatibility_score] = rand(100);
    # end

    # @guides.each do |g|
    #   if g[:compatibility_score].nil?
    #     g[:compatibility_label] = ''
    #   elsif g[:compatibility_score] > 75
    #     g[:compatibility_label] = 'compatibility-high'
    #   elsif g[:compatibility_score] > 50
    #     g[:compatibility_label] = 'compatibility-med'
    #   else
    #     g[:compatibility_label] = 'compatibility-low'
    #   end
    # end

    render :show
  end
end
