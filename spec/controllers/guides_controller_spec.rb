require 'spec_helper'

describe GuidesController do
  it 'directs to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end

  it 'renders a show page' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    expect(response).to render_template(:show)
  end

  it 'directs to edit page after successful guide creation'
  
  it 'redirects back to form after unsuccessful crop creation' do
    guide = FactoryGirl.attributes_for(:guide)
    guide[:name] = ''
    post 'create', guide: guide
    expect(response).to render_template(:new)
  end

  it 'should show the edit page if the user owns the guide' do
    guide = FactoryGirl.create(:guide)
    user = guide.user
    sign_in user
    get 'edit', id: guide.id
    expect(response).to render_template(:edit)
  end

  it 'should redirect to the guide if the user does not own it' do
    guide = FactoryGirl.create(:guide)
    user = FactoryGirl.create(:user)
    sign_in user
    get 'edit', id: guide.id
    response.should redirect_to "/guides/#{guide.id}"
  end

  it 'should show the index page' do
    get 'index'
    expect(response).to render_template(:index)
  end

  it 'should redirect to show after successful update'
    # Not sure this test makes sense, since this will be largely 
    # done through Ajax. as a result, does it still make sense 
    # to have the update path?
end
