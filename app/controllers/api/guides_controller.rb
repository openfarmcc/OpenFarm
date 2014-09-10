module Api
  class GuidesController < Api::Controller

    def create
      guide = Guide.new(guide_params)
      if guide.save
        render json: guide, status: :created
      else
        render json: guide.errors, status: :unprocessable_entity
      end
    end

    def show
      guide = Guide.find(params[:id])
      render json: guide
    end

    def update
      guide = Guide.find(params[:id])
      # TODO: Patch this hole for the entire API using before_filters
      raise 'opps' unless guide.user == current_user
      guide.update_attributes(guide_params)
      if guide.save
        render json: guide
      else
        render json: guide.errors, status: :unprocessable_entity
      end
    end

    private

    def guide_params
      output = params.require(:guide)
      if params[:featured_image]
        output[:featured_image] = URI(params[:featured_image])
      end
      output[:user_id] = current_user.id.to_s
      output
    end
  end
end
