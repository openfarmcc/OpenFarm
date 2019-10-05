# frozen_string_literal: true

class TokenSerializer < BaseSerializer
  attribute :expiration
  attribute :secret do
    object.fully_formed
  end
end
