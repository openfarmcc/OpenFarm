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
    warn 'PLAINTEXT NOT SET AUTH WILL ACT WEIRD' unless plaintext.present?
    "#{user.email}:#{plaintext}"
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

  # (String) plaintext: An email address, then a colon (':') then a token in
  # plaintext. Example: "rick@me.com:1234567"
  # Returns User object on success. Otherwise `false`
  def self.get_user(token)
    email, pt        = *token.split(':')
    user             = email && User.find_by(email: email)
    guess            = Digest::SHA512.hexdigest(pt)
    if user && user.token && Devise.secure_compare(user.token.secret, guess)
      user
    else
      false
    end
  end
end
