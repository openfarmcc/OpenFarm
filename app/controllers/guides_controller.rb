class GuidesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if current_user
      redirect_to user_path(current_user)
    else
      redirect_to root_path
    end
  end

  def show
    @guide = Guide.find(params[:id])
    impressionist(@guide, '', unique: [:session_hash])
  end

  def new
    @guide = Guide.new
  end

  def edit
    @guide = Guide.find(params[:id])

    # if not @guide.user.id == current_user.id
    redirect_to @guide
    # end
  end

  def destroy
    @outcome = Guides::DestroyGuide.run(params,
                                        user: current_user)
    redirect_to guides_path
  end
end
