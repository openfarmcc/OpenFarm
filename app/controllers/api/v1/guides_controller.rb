class Api::V1::GuidesController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index, :show]

  def create
    @outcome = Guides::CreateGuide.run(crop_id: "#{params[:crop_id]}",
                                       crop_name: "#{params[:crop_name]}",
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
    render json: serialize_model(guide, include: ['stages', 'stages.pictures'])
  end

  def update
    @outcome = Guides::UpdateGuide.run(attributes: params,
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
