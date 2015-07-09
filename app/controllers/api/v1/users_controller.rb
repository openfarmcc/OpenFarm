class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_from_token!, only: [:show]

  def show
    user = User.find(params[:id])
    if Pundit.policy(current_user, user).show?
      render json: serialize_model(user, include: ['user_setting',
                                                   'user_setting.picture',
                                                   'guides',
                                                   ])
    else
      raise OpenfarmErrors::NotAuthorized
    end
  end

  def update
    @outcome = Users::UpdateUser.run(
      user: params,
      current_user: current_user,
      featured_image: params[:featured_image],
      user_setting: params[:user_setting],
      id: "#{current_user._id}")

    respond_with_mutation(:ok)
  end
end
