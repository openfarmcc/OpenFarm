class Token
  include Mongoid::Document

  after_initialize :generate_access_token

  attr_reader :plaintext

  field :secret
  field :expiration, type: Time, default: ->{ Time.current + 1.month }
  validates :secret, :expiration, :user_id, presence: true
  belongs_to :user
  private

  def generate_access_token
      # Generate the secret
      @plaintext  = SecureRandom.hex
      # Encrypt the secret (in case the DB gets hacked.)
      self.secret = Digest::SHA256.hexdigest(SecureRandom.hex)
  end

  # (String) plaintext: An email address, then a colon (':') then a token in
  # plaintext. Example: "rick@me.com:1234567"
  # Returns User object on success. Otherwise `false`
  def self.get_user(token)
    email, plaintext = *token.split(':')
    user = email && User.find_by(email: email)
    guess = Digest::SHA256.hexdigest(plaintext)
    if user && Devise.secure_compare(user.token.secret, guess)
      return user
    end
    false
  end
end