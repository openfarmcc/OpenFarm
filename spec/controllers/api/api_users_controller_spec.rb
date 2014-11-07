require "spec_helper"

describe Api::UsersController, :type => :controller do
  include ApiHelpers

  let(:viewing_user) { FactoryGirl.create(:user) }
  let(:public_user) { FactoryGirl.create(:user) }
  let(:private_user) { FactoryGirl.create(:user, is_private: true) }

  it 'shows private user to an admin' do
    viewing_user.admin = true
    viewing_user.save
    sign_in viewing_user
    get 'show', id: private_user.id, format: :json
    expect(response.status).to eq(200)
    expect(json.length).to eq(1)
    expect(json['user']).to have_key('location')
  end

  it 'does not show private user to an ordinary user' do
    sign_in viewing_user
    get 'show', id: private_user.id, format: :json
    expect(response.status).to eq(401)
  end
end
