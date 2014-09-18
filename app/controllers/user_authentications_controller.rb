# NOTE TO FUTURE DEVELOPERS:

# This controller never saw use in production. It was an omniauth controller.
# I am going to comment it out to avoid confusing developers. We might bring
# it back at some point. If this is still commented out after 12/01/14, let's
# consider removing it completely

# class UserAuthenticationsController < ApplicationController
#   # GET twitter
#   # This is the OAuth callback URL for Twitter
#   def twitter
#     handle_omni_auth with_email: false
#   end

#   # GET facebook
#   # This is the OAuth callback URL for Facebook
#   def facebook
#     handle_omni_auth with_email: true
#   end

# private
#   # This method is extremely complex.
#   # FIXME: Refactor for lower complexity.
#   def handle_omni_auth args = {}
#     omni = request.env["omniauth.auth"]

#     user = User.where("user_authentications.provider" => omni["provider"],
#                       "user_authentications.uid" => omni["uid"]).first

#     if user
#       # They already associated this account, just log them in
#       flash[:notice] = "Logged in successfully"
#       sign_in_and_redirect user
#     elsif current_user
#       # They're logged in but haven't associated their account yet
#       current_user.apply_omniauth omni
#       current_user.save!

#       flash[:notice] = "Authentication successful."
#       sign_in_and_redirect current_user
#     elsif args[:with_email] and (user = User.where(email: omni["extra"][
#              "raw_info"].email).first)
#       # They have already signed up, link the account with this one
#       user.apply_omniauth omni
#       user.save!

#       flash[:notice] = "Authentication successful."
#       sign_in_and_redirect user
#     else
#       # They have not signed up yet, create them a user
#       user = User.new
#       user.display_name = omni["info"]["name"]
#       user.email = omni["extra"]["raw_info"].email if args[:with_email]
#       user.apply_omniauth omni

#       if user.save
#         flash[:notice] = "Logged in."
#         sign_in_and_redirect user
#       else
#         # This will usually happen if the provider does not give out the email
#         # *cough* Twitter *cough*
#         # Since email is a required field in Devise, redirect them to signup
#         # page and tell them to fill in their email.
#         session[:omniauth] = omni.except "extra"
#         redirect_to new_user_registration_path
#       end
#     end
#   end
# end

