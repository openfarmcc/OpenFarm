class Api::V1::DetailOptionsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index]

  def index
    render json: DetailOption.all
  end
end
