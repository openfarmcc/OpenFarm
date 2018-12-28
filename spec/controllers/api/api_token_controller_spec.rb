require 'spec_helper'

describe Api::V1::TokensController, type: :controller do

  include ApiHelpers

  let(:user) { FactoryBot.create(:confirmed_user) }

  it 'creates a token' do
    note """ Hit this API endpoint to generate an authentication token. Take the
    token that it returns and insert it as a request header like so:
     \`Authorization: Token token=YOUR_TOKEN_HERE\`
    """
    data = { email: user.email, password: user.password }
    Legacy.post :create, data, format: :json
    expect(response.status).to eq(201)
    user.reload
    token = json['data']['attributes']
    expiration = Time.parse(token['expiration'])
    email = token['secret'].split(':').first
    expect(User.find_by(email: email)).to eq(user)
    expect(token['secret']).to match(/#{user.email}\:.*/)
    expect(expiration).to be_a_kind_of(Time)
  end

  it 'handles bad passwords' do
    data = { email: user.email, password: 'wrong' }
    Legacy.post :create, data, format: :json
    expect(json['errors'][0]['title']).to eq('Invalid password.')
    expect(response.status).to eq(422)
  end

  it 'handles malformed emails' do
    data = { email: 'wrong', password: 'wrong' }
    Legacy.post :create, data, format: :json
    expect(json['errors'][0]['title']).to eq('Email isn\'t in the right format')
    expect(response.status).to eq(422)
  end

  it 'handles incorrect emails' do
    data = { email: 'wrong@no.com', password: 'wrong' }
    Legacy.post :create, data, format: :json
    expect(json['errors'][0]['title']).to eq('User not found.')
    expect(response.status).to eq(422)
  end

  it 'deletes a token' do
    note """You must be logged in to perform this action. No parameters are
    required. This is a log out action, essentially."""
    user = make_api_user
    expect(user.token).to be_a_kind_of(Token)
    Legacy.delete :destroy
    user.reload
    expect(response.status).to eq(204)
    expect(user.token).to eq(nil)
  end

  it 'handles attempts to destroy nil tokens' do
    # This would only happen to people trying to destroy a token while using
    # cookie auth.
    user = FactoryBot.create(:user)
    sign_in user
    Legacy.delete :destroy
    expect(response.status).to eq(404)
    expect(json['error']).to eq('your account has no token to destroy.')
  end
end
