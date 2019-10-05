# frozen_string_literal: true

class Api::V1::GuidesController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: %i[index show]

  def create
    # According to JSON-API Params must be structured like this:
    # {
    #  'data': {
    #     'type': 'guides',
    #     'id': '<id>',
    #     'attributes': {},
    # }
    @outcome =
      Guides::CreateGuide.run(
        raw_params[:data],
        crop_id: raw_params[:data][:crop_id], crop_name: raw_params[:data][:crop_name], user: current_user
      )
    respond_with_mutation(:created, include: %w[stages stages.pictures stages.stage_actions crop pictures user])
  end

  def show
    guide = Guide.find(raw_params[:id])
    render json: serialize_model(guide, include: %w[stages stages.pictures stages.stage_actions crop pictures user])
  end

  def update
    # According to JSON-API Params must be structured like this:
    # {
    #  'data': {
    #     'type': 'guides',
    #     'id': '<id>',
    #     'attributes': {},
    # }
    @outcome =
      Guides::UpdateGuide.run(
        { attributes: {} },
        raw_params[:data],
        user: current_user, guide: Guide.find(raw_params[:id])
      )
    respond_with_mutation(:ok, include: %w[stages stages.pictures stages.stage_actions crop pictures user])
  end

  def destroy
    @outcome = Guides::DestroyGuide.run(raw_params, user: current_user)
    respond_with_mutation(:no_content)
  end
end
