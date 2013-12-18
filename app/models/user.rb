class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
    
  field :email_address, type: String
  field :display_name, type: String
  field :password, type: String
  field :password_digest, type: String
  
  field :location, type:String
  field :soil_type
  field :preferred_growing_style
  field :years_experience, type: Integer
  
  validates_presence_of :email_address, :display_name
  validates_presence_of :password, :on => :create
  
  has_secure_password
end