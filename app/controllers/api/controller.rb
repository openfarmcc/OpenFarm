require 'openfarm_errors'

class Api::Controller < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  respond_to :json

  before_action :authenticate_from_token!

  rescue_from OpenfarmErrors::NotAuthorized do |exc|
    json = { error: "Not Authorized. #{exc.message}" }
    render json: json, status: 401
  end

  protected

  def authenticate_from_token!
    request.authorization.present? ? token_auth : authenticate_user!
  end

  def token_auth
    authenticate_or_request_with_http_token do |token, _options|
      user = Token::AuthorizationPolicy.new(token).build
      sign_in user, store: false if user
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
