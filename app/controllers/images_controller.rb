class ImagesController < ApplicationController
  def create
    @crop = Crop.find(params[:crop_id])
    @crop_image = @crop.images.new(image_params)
    puts @crop_image.inspect
    if @crop_image.save
      redirect_to(crop_path(@crop), notice: "Image uploaded successfully")
    else
      redirect_to(crop_path(@crop), alert: "Image upload failed")
    end
  end

  private
  def image_params
    params.require(:image).permit(:attachment)
  end
end
