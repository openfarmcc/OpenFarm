module Api
  class GuideRequirementOptionsController < Api::Controller
    skip_before_action :authenticate_user!, only: [:index]

    def index
      render json: GuideRequirementOption.all
    end

  end
end
