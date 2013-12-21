require 'spec_helper'

describe CropsController, :type => :controller do
  it 'Should direct to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end
  
  it 'Should render a edit page' do
    crop = FactoryGirl.create(:crop)
    get 'edit', :id => crop.id
    expect(response).to render_template(:edit)
  end
  
  it 'Should allow a page edit' do
    NEW_NAME = "Changed name"
    
    crop_attributes = FactoryGirl.attributes_for(:crop)
    crop = Crop.create(crop_attributes)
    crop_attributes[:name] = NEW_NAME
    put 'update', :id => crop.id, :crop => crop_attributes
    
    response.should redirect_to "/crops/#{assigns(:crop).id}"
    assigns(:crop).name.should == NEW_NAME
  end
  
  it 'Should not allow a page edit if display_name is missing' do
    crop_attributes = FactoryGirl.attributes_for(:crop)
    crop = Crop.create(crop_attributes)
    crop_attributes[:name] = ""
    put 'update', :id => crop.id, :crop => crop_attributes
    
    expect(response).to render_template(:edit)
  end
  
  it 'Should render a show page' do
    crop = FactoryGirl.create(:crop)
    get 'show', :id => crop.id
    expect(response).to render_template(:show)
  end
  
  it 'Should direct to show page after successful user creation' do
    crop = FactoryGirl.attributes_for(:crop)
    post 'create', :crop => crop
      response.should redirect_to "/crops/#{assigns(:crop).id}"
  end
  
  it 'Should redirect back to form after unsuccessful user creation' do
    crop = FactoryGirl.attributes_for(:crop)
    crop[:name] = ""
    post 'create', :crop => crop
    expect(response).to render_template(:new)
  end
end
