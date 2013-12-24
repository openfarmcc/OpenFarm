class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end
  
  def edit
    @user = User.find(params[:id])
    render :edit
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url
  end
  
  private
    def user_params
      params.require(:user).permit(:id, :display_name, :email_address, :password, :password_confirmation, :location, :soil_type, :preferred_growing_style, :years_experience)
    end
end