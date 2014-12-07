module Api
  class StagesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      @outcome = Stages::CreateStage.run(params, user: current_user)
      respond_with_mutation(:created)
    end

    def show
      stage = Stage.find(params[:id])
      render json: stage
    end

    def update
      stage = Stage.find(params[:id])
      @outcome = Stages::UpdateStage.run(params,
                                         stage: stage,
                                         user:  current_user)
      respond_with_mutation(:ok)
    end
  end
end
