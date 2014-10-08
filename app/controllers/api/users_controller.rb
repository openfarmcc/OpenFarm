module Api
  class UsersController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:show]

    def show
      user = User.find(params[:id])
      render json: user
    end
  end
end
