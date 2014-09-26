require 'spec_helper'

describe Token do
  let(:token) { FactoryGirl.create(:token) }

  it 'has a secret, plaintext, expiration and a user' do
    expect(token).to be_valid
    expect(token.plaintext.length).to eq(32)
    expect(token.secret).to eq(Digest::SHA512.hexdigest(token.plaintext))
    days_to_expiration = (token.expiration.to_date - Date.today).to_i
    expect(days_to_expiration).to be > 27
  end

  it 'requires a user' do
    token = FactoryGirl.build(:token, user: nil)
    expect(token.valid?).to eq(false)
  end

  it '#get_user returns a user when correct' do
    pt    = token.plaintext
    email = token.user.email
    key   = "#{email}:#{pt}"
    expect(Token.get_user(key)).to eq(token.user)
  end

  it '#get_user returns false when wrong' do
    pt    = 'notevenclose'
    email = token.user.email
    key   = "#{email}:#{pt}"
    expect(Token.get_user(key)).to eq(false)
  end
end