module Api
  class GuidesController < Api::Controller
    skip_before_action :authenticate_user!, only: [:index, :show]
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
      outcome = Guides::UpdateGuide.run(params,
                                user: current_user,
                                guide: Guide.find(params[:id]))
      if outcome.success?
        render json: outcome.result
      else
        render json: outcome.errors.message, status: :unprocessable_entity
      end
    end

    private

    def guide_params
      output = params.require(:guide)
      if params[:featured_image]
        output[:featured_image] = parse_url(params[:featured_image])
      end
      output[:user_id] = current_user.id.to_s
      output
    end

    # TODO: Add mutator gem to tell people they need absoloute URLs, etc etc
    # TODO: This does not belong in the controller at all. This is wrong.
    # bad bad bad.
    def parse_url(*_url)
      return 'http://openfarm.cc/img/page.png'
    rescue TypeError
      error = { error: 'The URL provided appears to not be valid' }
      render(json: error, status: :unprocessable_entity) and return
    end
  end
end
