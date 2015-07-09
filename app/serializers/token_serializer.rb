class TokenSerializer < BaseSerializer
  attribute :expiration
  attribute :secret

  def secret
    object.fully_formed
  end
end
