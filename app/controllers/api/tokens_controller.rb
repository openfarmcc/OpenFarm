module Api
  class TokensController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:create]

    def create
      @outcome = Tokens::Create.run(params)
      respond_with_mutation(:created)
    end

    def destroy
      render json: {error: 'not implemented yet.'}, status: :unavailable
    end
  end
end
