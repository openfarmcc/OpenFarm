class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:index, :finish, :gardens]

  def update
    authorize current_user

    user_settings = {
      units: params[:units],
      location: params[:location]
    }
    @outcome = Users::UpdateUser.run(
      attributes: params,
      current_user: current_user,
      user_setting: user_settings,
      id: "#{current_user._id}")

    if @outcome.errors
      flash[:alert] = @outcome.errors.message_list
      redirect_to(controller: 'users',
        action: 'finish')
    else
      redirect_to user_path(current_user)
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    # Fetch history trackers
    @trackers = History.limit(25)
    # get change set for the first tracker
    @changes = @trackers.first.tracked_changes
    #=> {field: {to: val1, from: val2}}
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
