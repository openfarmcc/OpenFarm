module Api
  class GuidesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      @outcome = Guides::CreateGuide.run(params, user: current_user)
      respond_with_mutation(:created)
      unless @outcome.errors
        flash[:notice] = t('guides.edit.successful_creation')
      end
    end

    def show
      guide = Guide.find(params[:id])
      render json: guide
    end

    def update
      @outcome = Guides::UpdateGuide.run(params,
                                user: current_user,
                                guide: Guide.find(params[:id]))
      respond_with_mutation(:ok)
    end
  end
end
