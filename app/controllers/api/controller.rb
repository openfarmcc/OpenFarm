class Api::Controller < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json
  before_action :authenticate_user!
end
