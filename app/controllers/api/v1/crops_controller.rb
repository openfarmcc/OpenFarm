# frozen_string_literal: true

class Api::V1::CropsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: %i[index show]

  def index
    render json: should_perform_search? ? search_result : empty_search_result
  end

  def show
    crop = Crop.find(raw_params[:id])
    render json: serialize_model(crop, include: %w[pictures companions])
  end

  def create
    @outcome = Crops::CreateCrop.run(raw_params[:data], user: current_user)
    respond_with_mutation(:ok, include: %w[pictures])
  end

  def update
    # According to JSON-API Params must be structured like this:
    # {
    #   'data': {
    #     'type': 'crops',
    #     'id': '<id>',
    #     'attributes': {
    #     },
    #   }
    # }
    @outcome = Crops::UpdateCrop.run(raw_params[:data], user: current_user, id: raw_params[:id])
    respond_with_mutation(:ok, include: %w[pictures])
  end

  private

  def crops
    @crops ||=
      Crop.search(
        raw_params[:filter],
        limit: 25,
        operator: 'or',
        misspellings: {
          # partial: true,
          distance: 1
        },
        fields: %w[name^20 common_names^10 binomial_name^10 description],
        boost_by: %i[guides_count]
      )
  end

  def should_perform_search?
    raw_params[:filter].present? && (raw_params[:filter].length > 2)
  end

  def empty_search_result
    p = raw_params[:page]
    model = p ? Crop.page(p) : Crop.none
    serialize_models(model)
  end

  def search_result
    serialize_models(crops, include: %w[pictures])
  end
end
