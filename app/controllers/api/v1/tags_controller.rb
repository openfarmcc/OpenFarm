class Api::V1::TagsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index]
  def index
    render json: {tags: CropsTagIndex.where(id: /#{Regexp.escape(params[:query].to_s)}/i).pluck(:id)}
  end
end
