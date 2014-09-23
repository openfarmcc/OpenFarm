class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Allow certain fields for devise - needed in Rails 4.0+
  before_filter :update_sanitized_params, if: :devise_controller?

  before_action :set_locale

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protected

  # This method allows devise to pass non standard attributes through and
  # thereby comply with 'strong parameters'.
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit *safe_user_attrs
    end

    devise_parameter_sanitizer.for(:account_update) do |user|
      user.permit *safe_user_attrs
    end
  end

  # List of attributes that are safe for mass assignment on User objects.
  def safe_user_attrs
    [:display_name, :location, :soil_type, :years_experience, :email, :password,
     :preferred_growing_style, :password_confirmation, :current_password]
  end

  def current_admin
    if current_user && current_user.admin?
      return current_user
    else
      flash[:notice] = 'I told you kids to get out of here!'
      redirect_to '/' and return
    end
  end
end
