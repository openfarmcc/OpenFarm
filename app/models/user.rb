class User
  include Mongoid::Document

  embeds_many :user_authentications
  has_many :guides
  has_many :gardens
  has_one :token, dependent: :delete
  accepts_nested_attributes_for :user_authentications
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
  field :location, type: String
  field :years_experience, type: Integer
  field :admin,   :type => Boolean, default: false

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable # , :omniauthable
  field :mailing_list, type: Mongoid::Boolean, default: false
end
