# ===NOT CURRENTLY IN USE (Sep. 2014)===
# This was built by @robbrit some time ago to support Oauth logins. Other
# priorities have prevented us from finishing up. Will finish later.
class UserAuthentication
  include Mongoid::Document

  embedded_in :user

  field :provider,     type: String
  field :uid,          type: String
  field :token,        type: String
  field :token_secret, type: String
end
