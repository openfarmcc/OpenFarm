class Api::V1::StageActionsController < Api::V1::BaseController
  def index
    stage = Stage.find(params[:stage_id])
    render json: serialize_models(stage.stage_actions)
  rescue Mongoid::Errors::DocumentNotFound
    render json: "Stage not found", status: 404
  end

  def destroy
    @outcome = StageActions::DestroyStageAction.run(raw_params,
                                                    user: current_user)
    respond_with_mutation(:no_content)
  end
end
