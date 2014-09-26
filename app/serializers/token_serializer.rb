class TokenSerializer < ApplicationSerializer
  attributes :expiration, :secret

  def secret
    object.fully_formed
  end
end