module Api
  class DetailOptionsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index]

    def index
      render json: DetailOption.all
    end
  end
end
