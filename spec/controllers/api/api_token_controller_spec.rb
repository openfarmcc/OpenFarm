require 'spec_helper'

describe Api::TokensController, type: :controller do

  include ApiHelpers

  let(:user) { FactoryGirl.create(:user) }

  it 'creates a token' do
    data = { email: user.email, password: user.password }
    post :create, data, format: :json
    expect(response.status).to eq(201)
    user.reload
    token      = json['token']
    expiration = Time.parse(token['expiration'])
    email      = token['secret'].split(':').first
    expect(User.find_by(email: email)).to eq(user)
    expect(token['secret']).to match(/#{user.email}\:.*/)
    expect(expiration).to be_a_kind_of(Time)
  end

  it 'deletes a token' do
    user = make_api_user
    expect(user.token).to be_a_kind_of(Token)
    delete :destroy
    user.reload
    expect(response.status).to eq(204)
    expect(user.token).to eq(nil)
  end
end
