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
      user_setting: user_settings,
      id: "#{current_user._id}")

    if @outcome.errors
      flash[:alert] = @outcome.errors.message_list
      redirect_to(controller: 'users',
        action: 'finish')
    else
      connect_to_mailchimp current_user.reload
      redirect_to(controller: 'users', action: 'gardens', manage: true)
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

  private

  def connect_to_mailchimp(user)
    gb = Gibbon::API.new
    if user.mailing_list
      list = gb.lists.list({ filters: { list_name: 'OpenFarm Subscribers' } })
      gb.lists.subscribe({ id: list['data'][0]['id'],
                           email: { email: user[:email] },
                           merge_vars: { :DNAME => user[:display_name] },
                           double_optin: false,
                           update_existing: true })

    end
    if user.help_list
      list = gb.lists.list({ filters: { list_name: 'OpenFarm Helpers' } })
      gb.lists.subscribe({ id: list['data'][0]['id'],
                           email: { email: user[:email] },
                           merge_vars: { :DNAME => user[:display_name] },
                           double_optin: false,
                           update_existing: true })

    end
  end
end
