class Api::V1::TagsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: %i[index]
  def index
    render json: CropsTagIndex.where(id: /#{Regexp.escape(params[:query].to_s)}/i).pluck(:id)
  end
end
