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
      user: params,
      current_user: current_user,
      user_setting: user_settings,
      id: "#{current_user._id}")

    if @outcome.errors
      flash[:alert] = @outcome.errors.message_list
      redirect_to(controller: 'users',
        action: 'finish')
    else
      connect_to_mailchimp current_user.reload
      redirect_to user_path(current_user)
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def index
    @users = policy_scope(User)
  end

  def finish
    authorize current_user
  end

  def gardens
    @gardens = current_user.gardens
    redirect_to user_path(current_user)
  end

  private

  # TODO: this should probably be moved to the user model
  # and performed on update.

  def connect_to_mailchimp(user)
    gb = Gibbon::API.new
    if user.mailing_list && user.confirmed?
      list = gb.lists.list({ filters: { list_name: 'OpenFarm Subscribers' } })
      gb.lists.subscribe({ id: list['data'][0]['id'],
                           email: { email: user[:email] },
                           merge_vars: { :DNAME => user[:display_name] },
                           double_optin: false,
                           update_existing: true })

    end
    if user.help_list && user.confirmed?
      list = gb.lists.list({ filters: { list_name: 'OpenFarm Helpers' } })
      gb.lists.subscribe({ id: list['data'][0]['id'],
                           email: { email: user[:email] },
                           merge_vars: { :DNAME => user[:display_name] },
                           double_optin: false,
                           update_existing: true })

    end
  end
end
