class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Allow certain fields for devise - needed in Rails 4.0+
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit :display_name, :location, :soil_type, :years_experience,
        :preferred_growing_style, :email, :password, :password_confirmation
    end
  end
end
