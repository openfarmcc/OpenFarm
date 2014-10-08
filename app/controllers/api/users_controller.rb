module Api
  class UsersController < Api::Controller
    def show
      user = User.find(params[:id])
      render json: user
    end
  end
end
