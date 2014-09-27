module Api
  class StagesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      guide = Guide.find(params[:guide][:_id])
      @outcome = Stages::CreateStage.run(params, 
                                guide: guide,
                                user: current_user)
      
      respond_with_mutation(:created)
    end

    def show
      stage = Stage.find(params[:id])
      render json: stage
    end

    def update
      stage = Stage.find(params[:id])
      @outcome = Stages::UpdateStage.run(params,
                                user: current_user,
                                stage: stage)
      respond_with_mutation(:ok)
    end
  end
end
