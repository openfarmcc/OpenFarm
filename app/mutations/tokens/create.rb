module Tokens
  class Create < Mutations::Command
    required do
      string :email, matches: /^[^@]+@[^@]+\.[^@]+$/
      string :password, empty: false
    end

    def validate
      validate_credentials
    end

    def execute
      create_token
    end

    def create_token
      Token.create(user: @user)
    end

    def validate_credentials
      @user = User.find_by(email: email)
      unless @user.valid_password?(password)
        add_error :password, :invalid, 'Invalid password.'
      end
    rescue Mongoid::Errors::DocumentNotFound
      add_error :email, :not_found, 'User not found.'
    end
  end
end
