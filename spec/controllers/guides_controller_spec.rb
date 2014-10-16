require 'spec_helper'

describe GuidesController do
  it 'directs to a new page' do
    user = FactoryGirl.create(:user)
    sign_in user
    get 'new'
    expect(response).to render_template(:new)
  end

  it 'renders a show page' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    expect(response).to render_template(:show)
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
    # TODO This is wrong. Should be `redirect_to guides_path(guide)`.
    response.should redirect_to "/en/guides/#{guide.slug}"
  end

  it 'should show the index page' do
    get 'index'
    expect(response).to render_template(:index)
  end

  it 'should add an impression if a user shows the guide' do
    guide = FactoryGirl.create(:guide)
    user = FactoryGirl.create(:user)
    sign_in user
    get 'show', id: guide.id
    guide.reload
    expect(guide.impressions_field).to eq(1)
  end

  it 'should add an impression if a guide is shown without a session' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    guide.reload
    expect(guide.impressions_field).to eq(1)
  end

  it 'should not add an impression if a guide is shown with same session' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    get 'show', id: guide.id
    guide.reload
    expect(guide.impressions_field).to eq(1)
  end
end
