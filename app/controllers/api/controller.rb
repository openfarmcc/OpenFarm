class Api::Controller < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json
  before_action :authenticate_user!

  protected

  def respond_with_mutation(status = :ok)
    if @outcome.success?
      render json: @outcome.result, status: status
    else
      render json: @outcome.errors.message, status: :unprocessable_entity
    end
  end
end
