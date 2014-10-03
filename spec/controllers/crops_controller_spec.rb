require 'spec_helper'
require 'uri'

describe CropsController, :type => :controller do
  it 'Should direct to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end

  it 'Should redirect to crop_searches' do
    get 'index'
    response.should redirect_to controller: 'crop_searches', action: 'search'
  end
  
  it 'Should render a show page' do
    crop = FactoryGirl.create(:crop)
    get 'show', :id => crop.id
    expect(response).to render_template(:show)
  end
  
  it 'Should direct to create guide page after successful crop creation' do
    crop = FactoryGirl.attributes_for(:crop)
    post 'create', :crop => crop
    expect(response.status).to eq(302)
    response.should redirect_to "/en/guides/new?crop_id=#{assigns(:crop).id}"
  end
  
  it 'Should redirect back to form after unsuccessful crop creation' do
    crop = FactoryGirl.attributes_for(:crop)
    crop[:name] = ""
    post 'create', :crop => crop
    expect(response).to render_template(:new)
  end
end