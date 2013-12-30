class UserAuthenticationsController < ApplicationController
  # GET twitter
  # This is the OAuth callback URL for Twitter
  def twitter
    handle_omni_auth with_email: false
  end

  # GET facebook
  # This is the OAuth callback URL for Facebook
  def facebook
    handle_omni_auth with_email: true
  end

private
  def handle_omni_auth args = {}
    omni = request.env["omniauth.auth"]

    user = User.where("user_authentications.provider" => omni["provider"],
                      "user_authentications.uid" => omni["uid"]).first

    if user
      # They already associated this account
      flash[:notice] = "Logged in successfully"
      sign_in_and_redirect user
    elsif current_user
      # They're logged in but haven't associated their account yet
      current_user.apply_omniauth omni
      current_user.save!

      flash[:notice] = "Authentication successful."
      sign_in_and_redirect current_user
    elsif args[:with_email] and (user = User.where(email: omni["extra"]["raw_info"].email).first)
      # They have already signed up, link the account with this one
      user.apply_omniauth omni
      user.save!

      flash[:notice] = "Authentication successful."
      sign_in_and_redirect user
    else
      user = User.new
      user.display_name = omni["info"]["name"]
      user.email = omni["extra"]["raw_info"].email if args[:with_email]
      user.apply_omniauth omni

      if user.save
        flash[:notice] = "Logged in."
        sign_in_and_redirect user
      else
        puts "wtf"
        puts user.errors.inspect
        session[:omniauth] = omni.except "extra"
        redirect_to new_user_registration_path
      end
    end
  end
end

