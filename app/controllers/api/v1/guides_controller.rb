class Api::V1::GuidesController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index, :show]

  def create
    # According to JSON-API Params must be structured like this:
    # {
    #  'data': {
    #     'type': 'guides',
    #     'id': '<id>',
    #     'attributes': {},
    # }
    puts "CREATE PARAMS #{params}"
    @outcome = Guides::CreateGuide.run(params[:data],
                                       crop_id: params[:data][:crop_id],
                                       crop_name: params[:data][:crop_name],
                                       user: current_user)
    respond_with_mutation(:created, include: ['stages',
                                              'stages.pictures',
                                              'crop',
                                              'user'])
    unless @outcome.errors
      flash[:notice] = t('guides.edit.successful_creation')
    end
  end

  def show
    guide = Guide.find(params[:id])
    render json: serialize_model(guide, include: ['stages',
                                                  'stages.pictures',
                                                  'crop',
                                                  'user'])
  end

  def update
    # According to JSON-API Params must be structured like this:
    # {
    #  'data': {
    #     'type': 'guides',
    #     'id': '<id>',
    #     'attributes': {},
    # }
    @outcome = Guides::UpdateGuide.run(params[:data],
                                       user: current_user,
                                       guide: Guide.find(params[:id]))
    respond_with_mutation(:ok, include: ['stages',
                                         'stages.pictures',
                                         'crop',
                                         'user'])
  end

  def destroy
    @outcome = Guides::DestroyGuide.run(params,
                                        user: current_user)
    respond_with_mutation(:no_content)
  end
end
