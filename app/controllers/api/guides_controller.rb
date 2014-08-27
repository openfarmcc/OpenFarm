module Api
  class GuidesController < Api::Controller
    def create
      crop = Guide.new(guide_params)
      if crop.save
        render json: crop
      else
        render json: crop.errors, status: :unprocessable_entity
      end
    end

    def guide_params
      output           = params.permit(:crop_id, :name, :overview)
      output[:user_id] = current_user
      output
    end
  end
end
