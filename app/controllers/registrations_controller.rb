class RegistrationsController < Devise::RegistrationsController
  def create
    super
    @outcome = Gardens::CreateGarden.run(
      params,
      user: current_user,
      name: I18n.t('registrations.your_first_garden'),
      description: I18n.t('registrations.generated_this_garden'),
      average_sun: 'Full Sun',
      type: 'Outdoors',
      soil_type: 'Loam'
    )

#     # session[:omniauth] = nil unless @user.new_record?
  end

  def destroy
    password = params[:user][:password_confirmation]
    if current_user.valid_password?(password)
      super
    else
      flash[:alert] = I18n.t('registrations.need_password')
      redirect_to(edit_user_registration_path(current_user))
    end
  end

  protected

  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-
  # specific-page-on-successful-sign-up-(registration)
  def after_sign_up_path_for(resource)
    # stored resource gets cleared after it gets called apparently
    go_to = stored_location_for(resource)
    if go_to
      go_to || request.referer || root_path
    else
      url_for(controller: 'users',
        action: 'finish')
    end
  end
end
