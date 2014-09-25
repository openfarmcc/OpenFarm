class Api::Controller < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  respond_to :json

  before_action :authenticate_from_token!

  protected

  def authenticate_from_token!
    authenticate_or_request_with_http_token do |token, options|
      user = Token.get_user(token)
      if user
        sign_in user, store: false
      else
        # TODO Use rescue_from hooks for all of these errors.
        msg = """Unauthorized. Please be aware that tokens follow the format of
         <email>:<token>. Example: "joe@yahoo.com:1ADASDsss" """.squish
        render json: {error: msg}, status: :unauthorized
      end
    end
  end

  def respond_with_mutation(status = :ok)
    if @outcome.success?
      render json: @outcome.result, status: status
    else
      render json: @outcome.errors.message, status: :unprocessable_entity
    end
  end
end
