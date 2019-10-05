# frozen_string_literal: true

require 'spec_helper'

describe Token::AuthorizationPolicy do
  let(:token) { FactoryBot.create(:token) }
  let(:policy) { Token::AuthorizationPolicy }

  it 'returns a user when correct' do
    pt = token.plaintext
    email = token.user.email
    key = "#{email}:#{pt}"
    expect(policy.new(key).build).to eq(token.user)
  end

  it 'raises Openfarm::NotAuthorized when wrong' do
    pt = 'notevenclose'
    email = token.user.email
    key = "#{email}:#{pt}"
    expect { policy.new(key).build }.to(raise_error(OpenfarmErrors::NotAuthorized))
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

  it 'raises Openfarm::NotAuthorized for bad email addresses' do
    pt = token.plaintext
    email = 'wrong@nope.com'
    key = "#{email}:#{pt}"
    expect { policy.new(key).build }.to(raise_error OpenfarmErrors::NotAuthorized, 'Invalid token or user email.')
  end

  it 'raises Openfarm::NotAuthorized for expired tokens' do
    pt = token.plaintext
    email = token.user.email
    key = "#{email}:#{pt}"
    token.update_attributes(expiration: 20.days.ago)
    expect { policy.new(key).build }.to(raise_error OpenfarmErrors::NotAuthorized, 'Expired token.')
  end
end
