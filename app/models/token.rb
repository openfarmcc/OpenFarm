class Token
  include Mongoid::Document
  before_create :generate_access_token

  field :encrypted_token, type: String

  private

  def generate_access_token
    self.access_token = Digest::SHA256.hexdigest(Time.now.to_s)
  end
end