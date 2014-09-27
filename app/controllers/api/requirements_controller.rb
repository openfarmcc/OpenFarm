module Api
  class RequirementsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      guide = Guide.find(params[:guide][:_id])
      @outcome = Requirements::CreateRequirement.run(params, 
                                guide: guide,
                                user: current_user)
      # TODO something with #@outcome.errors
      respond_with_mutation(:created)
    end

    def show
      requirement = Requirement.find(params[:id])
      render json: requirement
    end

    def update
      @outcome = Requirements::UpdateRequirement.run(params,
                                user: current_user,
                                requirement: Requirement.find(params[:id]))
      respond_with_mutation(:ok)
    end

    def destroy
      Requirement.find(params[:id]).destroy
      render json: {}
    end
  end
end
