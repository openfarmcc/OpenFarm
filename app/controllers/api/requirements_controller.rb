module Api
  class RequirementsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      puts "creating: " + params.to_s
      @outcome = Requirements::CreateRequirement.run(params[:stage], guide: params[:guide], user: current_user)
      puts @outcome.success?
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
  end
end
