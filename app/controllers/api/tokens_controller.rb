# OUT OF DATE, Don't use. 08/07/2015
module Api
  class TokensController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:create]

    def create
      @outcome = Tokens::Create.run(params)
      respond_with_mutation(:created)
    end

    def destroy
      if current_user.token && current_user.token.destroy
        render nothing: true, status: :no_content
      else
        err = { error: 'your account has no token to destroy.' }
        render json: err, status: :not_found
      end
    end
  end
end
