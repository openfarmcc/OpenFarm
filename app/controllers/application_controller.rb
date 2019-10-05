# frozen_string_literal: true

# OUT OF DATE

class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Mongoid::Errors::DocumentNotFound, with: :record_not_found
  protect_from_forgery with: :exception
  helper :all
  # Allow certain fields for devise - needed in Rails 4.0+
  before_action :update_sanitized_params, if: :devise_controller?

  before_action :set_locale, :check_for_confirmation

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_for_confirmation
    flash[:warning] = I18n.t('users.need_confirmation') if current_user && !current_user.confirmed?
  end

  # OpenFarm uses the `Mutations` gem for most API operations.
  # Since mutations provides its own sanitization methods, there is no need to
  # use Rails param helpers
  def raw_params
    @raw_params ||= params.as_json.deep_symbolize_keys
  end

  protected

  # This method allows devise to pass non standard attributes through and
  # thereby comply with 'strong parameters'.
  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up) { |params| params.permit *safe_user_attrs }

    devise_parameter_sanitizer.permit(:account_update) do |params|
      params.permit *(safe_user_attrs << :current_password)
    end
  end

  # List of attributes that are safe for mass assignment on User objects.
  def safe_user_attrs
    %i[display_name email location password units years_experience mailing_list is_private agree]
  end

  private

  def record_not_found
    render file: "#{Rails.root}/public/404", formats: %i[html], status: 404, layout: false
  end

  def user_not_authorized(exception)
    flash[:alert] = "You're not authorized to go to there."
    if !current_user
      store_location_for(:user, new_crop_path)

      return redirect_to(new_user_session_path)
    end
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for(resource)
    go_to = stored_location_for(resource)

    go_to ? go_to || request.referer || root_path : url_for(root_path)
  end
end
