require 'spec_helper'

describe UsersController do
  it 'should show the user their profile' do
    user = FactoryGirl.create(:user)

    sign_in user
    get 'show', id: user.id
    expect(response).to render_template(:show)
  end

  it 'should show the user a public profile' do
    user = FactoryGirl.create(:user)
    public_user = FactoryGirl.create(:user, is_private: false)
    sign_in user
    get 'show', id: public_user.id
    expect(response).to render_template(:show)
  end

  it 'should not show the user a private profile' do
    user = FactoryGirl.create(:user)
    private_user = FactoryGirl.create(:user, is_private: true)
    sign_in user
    get 'show', id: private_user.id
    expect(response).to redirect_to root_path(locale: 'en')
  end

  it 'should only show public users on index' do
    user = FactoryGirl.create(:user)
    private_user = FactoryGirl.create(:user, is_private: true)
    public_user = FactoryGirl.create(:user)
    sign_in user
    get 'index'
    expect(assigns(:users)).to match_array([public_user, user])
  end

  it 'should show all users on index if the current user is admin' do
    user = FactoryGirl.create(:user, admin: true)
    private_user = FactoryGirl.create(:user, is_private: true)
    public_user = FactoryGirl.create(:user)
    sign_in user
    get 'index'
    expect(assigns(:users)).to match_array([public_user, user, private_user])
  end
end
