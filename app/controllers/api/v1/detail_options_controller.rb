class Api::V1::DetailOptionsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: %i[index]

  def index
    render json: serialize_models(DetailOption.all)
  end
end
