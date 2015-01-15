class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:index, :finish, :gardens]

  def update
    authorize current_user
    @outcome = Users::UpdateUser.run(
      user: params,
      id: "#{current_user._id}")

    if @outcome.errors
      flash[:alert] = @outcome.errors.message_list
      redirect_to(controller: 'users',
        action: 'finish')
    else
      redirect_to(controller: 'users',action: 'gardens', manage: true)
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def index
    @users = policy_scope(User)
  end

  def gardens
    @gardens = current_user.gardens
  end
end
