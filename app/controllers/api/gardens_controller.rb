module Api
  class GardensController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def show
      garden = Garden.find(params[:id])
      if Pundit.policy!(current_user, garden)
        render json: garden
      else
        raise OpenfarmErrors::NotAuthorized
      end
    end

    def index
      gardens = Pundit.policy_scope(current_user, Garden)
      render json: gardens
    end
  end
end
