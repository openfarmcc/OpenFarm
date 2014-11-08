module Api
  class RequirementsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create

      @outcome = Requirements::CreateRequirement.run(params,
                                                     user: current_user)
      respond_with_mutation(:created)
    end

    def show
      requirement = Requirement.find(params[:id])
      render json: requirement
    end

    def update
      requirement = Requirement.find(params[:id])
      @outcome = Requirements::UpdateRequirement.run(params,
                                                     user: current_user,
                                                     requirement: requirement)
      respond_with_mutation(:ok)
    end

    def destroy
      @outcome = Requirements::DestroyRequirement.run(params,
                                                     user: current_user)
      respond_with_mutation(:no_content)
    end
  end
end
