class Api::V1::StageActionOptionsController < Api::V1::Controller
  skip_before_action :authenticate_from_token!, only: [:index]

  def index
    render json: serialize_models(StageActionOption.all)
  end
end
