class Api::V1::IconsController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:index, :show]

  ICON_QUERY = { limit: 25,
                 partial: true,
                 misspellings: { distance: 1 },
                 fields: ['name', 'description'] }

  def index
    q = params[:filter]
    if q.present? && (q.length > 2) # Avoid excessive live search.
      icons = Icon.search(q, ICON_QUERY)
      render json: serialize_models(icons)
    else
      render json: serialize_models(Icon.none)
    end
  end

  def show
    render json: serialize_model(Icon.find(params[:id]))
  end

  def create
    @outcome = Icons::Create.run(params[:data], user: current_user)
    respond_with_mutation(:ok)
  end
end
