class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: %i[index finish gardens]

  def update
    authorize current_user

    user_settings = { units: raw_params[:units], location: raw_params[:location] }
    @outcome =
      Users::UpdateUser.run(
        attributes: raw_params,
        current_user: current_user,
        user_setting: user_settings,
        pictures: raw_params[:pictures],
        id: "#{current_user._id}"
      )

    if @outcome.errors
      flash[:alert] = @outcome.errors.message_list
      redirect_to(controller: 'users', action: 'finish')
    else
      redirect_to user_path(current_user)
    end
  end

  def show
    @user = User.find(raw_params[:id])
    authorize @user
  end

  def index
    @users = policy_scope(User)
  end

  def edit
    authorize current_user
  end

  def finish
    authorize current_user
  end

  def gardens
    @gardens = current_user.gardens
    redirect_to user_path(current_user)
  end
end
