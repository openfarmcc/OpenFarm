class CropSearchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :search

  def search
    query = params[:q].to_s.encode('utf-8', 'iso-8859-1')

    @crops = Crop.search(query,
                         limit: 25,
                         partial: true,
                         misspellings: {distance: 2},
                         fields: ['name^20',
                                  'common_names^10',
                                  'binomial_name^10',
                                  'description'],
                         boost_by: [:guides_count]
                        )
    if query.empty?
      @crops = Crop.search('*', limit: 25, boost_by: [:guides_count])
    end

    @guides = GuideSearch.search('*').ignore_drafts.for_crops(@crops).with_user(current_user)

    @guides = Guide.sorted_for_user(@guides, current_user)

    render :show
  end

  private

  def sort_guides(current_user)

  end
end
