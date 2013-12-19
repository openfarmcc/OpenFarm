class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
    
  field :email_address, type: String
  field :display_name, type: String
  field :password, type: String
  field :password_digest, type: String
  
  field :location, type: String
  field :soil_type, type: String
  field :preferred_growing_style, type: String
  field :years_experience, type: Integer
  
  validates_presence_of :email_address, :display_name
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email_address
  validates_confirmation_of :password
  
  has_secure_password
end