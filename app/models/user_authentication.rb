class UserAuthentication
  include Mongoid::Document

  embedded_in :user

  field :provider,     type: String
  field :uid,          type: String
  field :token,        type: String
  field :token_secret, type: String
end
