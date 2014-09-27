module Api
  class StageOptionsController < Api::Controller
    skip_before_action :authenticate_user!, only: [:index]

    def index
      render json: StageOption.all
    end

  end
end
