class Token
  class AuthorizationPolicy
    attr_reader :email, :user, :guess

    def initialize(token_string)
      @email, pt = *token_string.split(':')
      @guess     = Digest::SHA512.hexdigest(pt)
    end

    def build
      check_user
      check_token
      check_expiration
      user
    end

    def check_token
      unless Devise.secure_compare(user.token.secret, guess)
        fail OpenfarmErrors::NotAuthorized, 'Invalid token or user email.'
      end
    end

    def check_expiration
      if Date.today > user.token.expiration
        fail OpenfarmErrors::NotAuthorized, 'Expired token.'
      end
    end

    def check_user
      @user = User.find_by(email: email)
    rescue Mongoid::Errors::DocumentNotFound
      raise OpenfarmErrors::NotAuthorized, 'Invalid token or user email.'
    end
  end
end
