require 'spec_helper'

describe UsersController, :type => :controller do
  it 'Should direct to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end
  
  it 'Should render a show page' do
    user = FactoryGirl.create(:user)
    get 'show', :id => user.id
    expect(response).to render_template(:show)
  end
  
  it 'Should direct to show page after successful user creation' do
    user = FactoryGirl.attributes_for(:user)
    post 'create', :user => user
    response.should redirect_to "/users/#{assigns(:user).id}"
  end
  
  it 'Should redirect back to form after unsuccessful user creation' do
    user = FactoryGirl.attributes_for(:user)
    user[:password] = nil
    post 'create', :user => user
    expect(response).to render_template(:new)
  end
  
  it 'Should allow a user to be deleted' do
    user = User.create(FactoryGirl.attributes_for(:user))
    delete 'destroy', :id => user.id
    expect(response).to redirect_to root_url
  end
end