class Api::V1::StagesController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index, :show]

  def create
    # According to JSON-API Params must be structured like this:
    # {
    #  'data': {
    #     'type': 'crops',
    #     'id': '<id>',
    #     'attributes': {},
    # }
    @outcome = Stages::CreateStage.run(params[:data],
                                       user: current_user)
    respond_with_mutation(:created, include: ['pictures'])
  end

  def show
    stage = Stage.find(params[:id])
    render json: serialize_model(stage, include: ['pictures'])
  end

  def update
    # According to JSON-API params must be structured like this:
    # {
    #  'data': {
    #     'type': 'stages',
    #     'id': '<id>',
    #     'attributes': {},
    #     'actions',
    #     'images'
    #  }
    # UpdateStage is being funny, issue reported here:
    # https://github.com/cypriss/mutations/issues/85
    @outcome = Stages::UpdateStage.run(params[:data],
                                       actions: params[:data][:actions],
                                       images: params[:data][:images],
                                       stage: Stage.find(params[:id]),
                                       user: current_user)
    respond_with_mutation(:ok, include: ['pictures'])
  end

  def destroy
    @outcome = Stages::DestroyStage.run(params,
                                        user: current_user)
    respond_with_mutation(:no_content)
  end

  def pictures
    stage = Stage.find(params[:stage_id])
    render json: serialize_models(stage.pictures)
  end
end
