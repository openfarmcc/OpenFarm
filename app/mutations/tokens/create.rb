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
      add_error :password, :invalid, 'Invalid password.' unless @user.valid_password?(password)
    rescue Mongoid::Errors::DocumentNotFound
      add_error :email, :not_found, 'User not found.'
    end
  end
end
