module Api
  class GuidesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      # TODO: something went wrong here, this can be cleaned up.
      @outcome = Guides::CreateGuide.run(crop_id: params[:crop_id],
                                         name: params[:name],
                                         attributes: params,
                                         # time_span: params[:time_span],
                                         user: current_user)
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
      @outcome = Guides::UpdateGuide.run(attributes: params,
                                         # time_span: params[:time_span],
                                         user: current_user,
                                         guide: Guide.find(params[:id]))
      respond_with_mutation(:ok)
    end

    def destroy
      @outcome = Guides::DestroyGuide.run(params,
                                          user: current_user)
      respond_with_mutation(:no_content)
    end
  end
end
