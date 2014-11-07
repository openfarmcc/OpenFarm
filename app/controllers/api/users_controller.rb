module Api
  class UsersController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:show]

    def show
      user = User.find(params[:id])
      render json: user
    end

    def index
      users = Pundit.policy_scope(current_user, User)
      render json: users
    end
  end
end
