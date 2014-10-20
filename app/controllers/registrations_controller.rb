class RegistrationsController < Devise::RegistrationsController
  def create
    super
    @outcome = Gardens::CreateGarden.run(
      params,
      user: current_user,
      name: "Your First Garden",
      description: "We created this garden automatically to get you started" +
                   ". You can edit it to better suit your needs!")
    if @outcome.errors
      puts @outcome.errors.message
    end
    
#     # session[:omniauth] = nil unless @user.new_record?
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
      edit_user_registration_path
    end
  end
end
