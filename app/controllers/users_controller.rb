class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:index, :finish]

  def update
    authorize current_user
    @outcome = Users::UpdateUser.run(
      params,
      user: current_user)

    if @outcome.errors
      flash[:alert] = @outcome.errors.message_list
      redirect_to(controller: 'users', 
        action: 'finish')
    else
      redirect_to :gardens
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def index
    @users = policy_scope(User)
  end
end
