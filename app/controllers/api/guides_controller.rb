module Api
  class GuidesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create

      # TODO: This should be moved into the mutation.
      # Basically we check if the crop exists, if it doesn't
      # we create a new one.

      crop_id = check_if_crop_exists(params)

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
      unless params[:crop_id].present?
        puts params[:crop_name]
        crops = Crop.search params[:crop_name], fields: [{name: :exact}]
        puts 'search found', crops.to_json
        if crops.count == 0
          crop = Crop.new({name: params[:crop_name],
                    common_names: [params[:crop_name],]})
          crop.save
          crop_id = crop.id
        else
          puts 'found a crop'
          crop_id = crops[0].id
        end
      else
        crop_id = params[:crop_id]
      end
    end
  end
end
