module Api
  class UsersController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:show]

    def show
      user = User.find(params[:id])
      if Pundit.policy(current_user, user).show?
        render json: user
      else
        raise OpenfarmErrors::NotAuthorized
      end
    end

    # TODO: figure out how to make this work with nested
    # def index
    #   users = Pundit.policy_scope(current_user, User)
    #   render json: { users: users }
    # end
  end
end
