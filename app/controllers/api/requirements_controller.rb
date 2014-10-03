module Api
  class RequirementsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      @outcome = Requirements::CreateRequirement.run(params,
                                                     user: current_user)
      # TODO something with #@outcome.errors
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
      # TODO Fix the respond_with_mutation method to take a mutation by value
      # and automatically infer the response.
      @outcome = Requirements::DestroyRequirement.run(params,
                                                     user: current_user)
      if @outcome.success?
        render nothing: true, status: :no_content
      else
        render json: @outcome.errors.message, status: :unprocessable_entity
      end
      # Requirement.find(params[:id]).destroy
      # render json: {}
    end
  end
end
