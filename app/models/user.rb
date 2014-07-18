class User
  include Mongoid::Document

  embeds_many :user_authentications
  has_many :guides

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock
  #   strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is
  # :email or :both
  # field :locked_at,       :type => Time

  field :display_name, type: String
  validates_presence_of :display_name
  field :location, type: String
  field :soil_type, type: String
  field :preferred_growing_style, type: String
  field :years_experience, type: Integer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def apply_omniauth omni
    user_authentications << UserAuthentication.new(
      provider: omni["provider"],
      uid: omni["uid"],
      token: omni["credentials"].token,
      token_secret: omni["credentials"].secret
    )
  end

  def password_required?
    # Don't need password if we're using OAuth
    (user_authentications.empty? || !password.blank?) && super
  end

  def update_with_password params, *options
    # Need to handle cases where the user authenticates through OAuth and not
    # through email/passwords
    if encrypted_password.blank?
      update_attributes params, *options
    else
      super
    end
  end
end
