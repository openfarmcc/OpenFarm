module Api
  class RequirementOptionsController < Api::Controller
    skip_before_action :authenticate_user!, only: [:index]

    def index
      render json: RequirementOption.all
    end

  end
end
