class TokenSerializer < BaseSerializer
  attribute :expiration
  attribute :secret do
    object.fully_formed
  end
end
