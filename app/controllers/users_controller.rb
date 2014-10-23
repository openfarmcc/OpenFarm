class UsersController < ApplicationController
  def update
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
end
