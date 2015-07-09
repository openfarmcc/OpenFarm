# OUT OF DATE, Don't use. 08/07/2015
module Api
  class GuidesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      # TODO: This should be moved into the mutation.
      # Basically we check if the crop exists, if it doesn't
      # we create a new one.
      if params[:crop_id].present?
        crop_id = params[:crop_id]
      else
        crop_id = check_if_crop_exists(params)
      end

      @outcome = Guides::CreateGuide.run(crop_id: "#{crop_id}",
                                         name: params[:name],
                                         attributes: params,
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

    private

    def check_if_crop_exists(params)
      crops = Crop.search params[:crop_name], fields: [{ name: :exact }]
      if crops.count == 0
        crop = Crop.new( name: params[:crop_name],
                         common_names: [params[:crop_name],] )
        crop.save
        crop.id
      else
        crops[0].id
      end
    end
  end
end
