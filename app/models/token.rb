class Token
  include Mongoid::Document

  before_validation :generate_access_token

  attr_reader :plaintext

  field :secret
  field :expiration, type: Time, default: ->{ Time.current + 30.days }
  validates :secret, :expiration, :user_id, presence: true
  belongs_to :user

  # Creates a token the way it would be sent to a controller. Ex: "t@g.com:1234"
  def fully_formed
    if plaintext.present?
      "#{user.email}:#{plaintext}"
    else
      # This error takes place when you attempt to pull up a unencrypted token
      # token from an object that has already been store in the database. We do
      # not store unencrypted tokens, so the only way to fix this error is to
      # destroy the token and create a new one.
      'EXPIRED - CANT RETRIEVE'
    end
  end

  private

  # Performs two actions: 1. Temporarily stores the plaintext token.
  # 2. Hashes the token and stores it to the database.
  def generate_access_token
    # Generate the secret
    # Encrypt the secret (in case the DB gets hacked.)
    if self.new_record? && !self.secret?
      @plaintext  = SecureRandom.hex
      self.secret = Digest::SHA512.hexdigest(plaintext)
    end
  end
end
