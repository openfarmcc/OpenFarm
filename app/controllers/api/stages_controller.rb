module Api
  class StagesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      puts "creating: " + params.to_s
      @outcome = Stages::CreateStage.run(params, user: current_user)
      puts @outcome.success?
      respond_with_mutation(:created)
    end

    def show
      stage = Stage.find(params[:id])
      render json: stage
    end

    def update
      @outcome = Stages::UpdateStage.run(params,
                                user: current_user,
                                stage: Stage.find(params[:id]))
      respond_with_mutation(:ok)
    end
  end
end
