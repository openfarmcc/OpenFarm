class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def build_resource(*args)
    super
    if session[:omniauth]
      omni = session[:omniauth]
      @user.apply_omniauth omni
      @user.display_name = omni["info"]["name"]
      @user.valid?
    end
  end
end
