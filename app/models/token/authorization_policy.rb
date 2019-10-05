# frozen_string_literal: true

class Token
  class AuthorizationPolicy
    attr_reader :email, :user, :guess

    def initialize(token_string)
      @email, pt = *token_string.split(':')
      @guess = Digest::SHA512.hexdigest(pt)
    end

    def build
      check_user
      check_token
      check_expiration
      return user
    end

    def check_token
      unless Devise.secure_compare(user.token.secret, guess)
        raise OpenfarmErrors::NotAuthorized, 'Invalid token or user email.'
      end
    end

    def check_expiration
      raise OpenfarmErrors::NotAuthorized, 'Expired token.' if Date.today > user.token.expiration
    end

    def check_user
      @user = User.find_by(email: email)
    rescue Mongoid::Errors::DocumentNotFound
      raise OpenfarmErrors::NotAuthorized, 'Invalid token or user email.'
    end
  end
end
