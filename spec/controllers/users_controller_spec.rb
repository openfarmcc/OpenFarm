require 'spec_helper'

describe UsersController, :type => :controller do
  it 'Should direct to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end
  
  it 'Should render a edit page' do
    user = FactoryGirl.create(:user)
    get 'edit', :id => user.id
    expect(response).to render_template(:edit)
  end
  
  it 'Should allow a page edit' do
    NEW_NAME = "Changed name"
    
    user_attributes = FactoryGirl.attributes_for(:user)
    user = User.create(user_attributes)
    user_attributes[:display_name] = NEW_NAME
    put 'update', :id => user.id, :user => user_attributes
    
    response.should redirect_to "/users/#{assigns(:user).id}"
    assigns(:user).display_name.should == NEW_NAME
  end
  
  it 'Should not allow a page edit if display_name is missing' do
    user_attributes = FactoryGirl.attributes_for(:user)
    user = User.create(user_attributes)
    user_attributes[:display_name] = ""
    put 'update', :id => user.id, :user => user_attributes
    
    expect(response).to render_template(:edit)
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