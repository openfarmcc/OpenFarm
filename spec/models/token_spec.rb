require 'spec_helper'
require 'openfarm_errors'

describe Token do
  let(:token) { FactoryBot.create(:token) }

  it 'has a secret, plaintext, expiration and a user' do
    expect(token).to be_valid
    expect(token.plaintext.length).to eq(32)
    expect(token.secret).to eq(Digest::SHA512.hexdigest(token.plaintext))
    days_to_expiration = (token.expiration.to_date - Date.today).to_i
    expect(days_to_expiration).to be > 27
  end

  it 'requires a user' do
    token = FactoryBot.build(:token, user: nil)
    expect(token.valid?).to eq(false)
  end

  it 'gives error messages if accessing a GCed token' do
    id = token._id
    token = nil # Garbage collect the newly created token.
    token = Token.find id
    expect { token.fully_formed }.to raise_error(OpenfarmErrors::StaleToken)
  end

  it 'provides email and plaintext for newly created tokens' do
    expect(token.fully_formed).to eq("#{token.user.email}:#{token.plaintext}")
  end
end
