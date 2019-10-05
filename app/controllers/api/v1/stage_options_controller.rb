# frozen_string_literal: true

class Api::V1::StageOptionsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: %i[index]

  def index
    render json: serialize_models(StageOption.all)
  end
end
