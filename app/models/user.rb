class User
  include Mongoid::Document

  def encrypted_password=(value)
    write_attribute(:encrypted_password, value)
  end

  has_many :guides
  has_many :gardens
  has_one :token, dependent: :delete
  has_one :user_setting
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

  field :display_name, type: String
  validates_presence_of :display_name

  field :agree, type: Boolean
  validates :agree, acceptance: { accept: true,
                                  message: 'to the Terms of Service and ' +
                                           'Privacy Policy' },
                    on: :create

  # TODO: These are being moved to user_setting.rb, once
  # the migration is complete on the server,
  # delete them on user.rb ~@simonv3 16/03/2015

  field :location, type: String
  field :years_experience, type: Integer
  field :units, type: String

  field :mailing_list, type: Mongoid::Boolean, default: false

  field :admin, type: Mongoid::Boolean, default: false

  # Privacy fields
  field :is_private, type: Mongoid::Boolean, default: false
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         # , :omniauthable

  # These are needed to be defined. Dunno why this doesn't
  # get automatically generated. Part of Devise.Confirmable
  # http://stackoverflow.com/a/9952241/154392
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String

  has_merit

  def user_setting
    UserSetting.find_or_create_by(user: self)
  end
end
