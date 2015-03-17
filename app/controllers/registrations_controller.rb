class RegistrationsController < Devise::RegistrationsController
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

  # TODO: this isn't relevant anymore now that confirmation
  # emails are getting sent on sign up. There must be a way to
  # figure this out though:
  # have a look at: http://stackoverflow.com/questions/6499589/devise-redirect-page-after-confirmation

  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-up-(registration)
  # def after_sign_up_path_for(resource)
  #   # stored resource gets cleared after it gets called apparently
  #   go_to = stored_location_for(resource)
  #   if go_to
  #     go_to || request.referer || root_path
  #   else
  #     url_for(controller: 'users',
  #       action: 'finish')
  #   end
  # end
end
