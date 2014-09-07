module Api
  class GuidesController < Api::Controller
    def create
      guide = Guide.new(guide_params)
      if guide.save
        render json: guide
      else
        render json: guide.errors, status: :unprocessable_entity
      end
    end

    def show
      guide = Guide.find(params[:id])
      if guide
        render json: guide
      else
        # ToDo: This isn't right.
        render json: {}, status: :not_found
      end
    end

    def update
      guide = Guide.find(params[:id])
      guide.update_attributes(guide_params)
      if guide.save
        render json: guide
      else
        render json: guide.errors, status: :unprocessable_entity
      end
    end

    private

    def guide_params
      output           = params.permit(:crop_id, :name, :overview)
      output[:user_id] = current_user
      output
    end
  end
end
