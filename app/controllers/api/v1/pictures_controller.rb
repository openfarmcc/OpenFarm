class Api::V1::PicturesController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index]

  def index
    puts params
    crop = Crop.find(params[:crop_id])
    render json: serialize_models(crop.pictures)
  end

  def show
    crop = Crop.find(params[:crop_id])
    render json: serialize_models(crop.pictures.find(params[:id]))
  end
end
