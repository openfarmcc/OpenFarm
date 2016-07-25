require 'spec_helper'
require 'openfarm_errors'

describe GuidesController do
  it 'directs to a new page' do
    user = FactoryGirl.create(:user)
    sign_in user
    get 'new'
    expect(response).to render_template(:new)
    expect(response.status).to eq(200)
  end

  it 'renders a show page' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    expect(response).to render_template(:show)
    expect(response.status).to eq(200)
  end

  it 'should show the edit page if the user owns the guide' do
    guide = FactoryGirl.create(:guide)
    user = guide.user
    sign_in user
    get 'edit', id: guide.id
    expect(response).to redirect_to "/en/guides/#{guide.slug}"
    expect(response.status).to eq(302)
  end

  it 'should redirect to the guide if the user does not own it' do
    guide = FactoryGirl.create(:guide)
    user = FactoryGirl.create(:user)
    sign_in user
    get 'edit', id: guide.id
    # TODO This is wrong. Should be `redirect_to guides_path(guide)`.
    expect(response).to redirect_to "/en/guides/#{guide.slug}"
    expect(response.status).to eq(302)
  end

  it 'should access logged in user profile page when accessing index' do
    user = FactoryGirl.create(:user)
    sign_in user
    get 'index'
    expect(response).to redirect_to ({ controller: 'users',
                                       action: 'show',
                                       id: user.id,
                                       locale: 'en' })
    expect(response.status).to eq(302)
  end

  it 'should access root page when accessing index not logged in' do
    get 'index'
    expect(response).to redirect_to "/en"
    expect(response.status).to eq(302)
  end

  # disabling impressionist for now because it's a likely
  # culprit for slowing everything really down on the server.
  # ~ Simon 07/2016
  # it 'should add an impression if a user shows the guide' do
  #   guide = FactoryGirl.create(:guide)
  #   user = FactoryGirl.create(:user)
  #   sign_in user
  #   get 'show', id: guide.id
  #   guide.reload
  #   expect(guide.impressions_field).to eq(1)
  #   expect(response.status).to eq(200)
  # end

  # it 'should add an impression if a guide is shown without a session' do
  #   guide = FactoryGirl.create(:guide)
  #   get 'show', id: guide.id
  #   guide.reload
  #   expect(guide.impressions_field).to eq(1)
  #   expect(response.status).to eq(200)
  # end

  # it 'should not add an impression if a guide is shown with same session' do
  #   guide = FactoryGirl.create(:guide)
  #   get 'show', id: guide.id
  #   get 'show', id: guide.id
  #   guide.reload
  #   expect(guide.impressions_field).to eq(1)
  #   expect(response.status).to eq(200)
  # end

  it 'should delete a guide' do
    user = FactoryGirl.create(:user)
    guide = FactoryGirl.create(:guide, user: user)
    sign_in user
    delete 'destroy', id: guide.id

    expect(response.status).to eq(302)
  end

  it 'should not delete a guide if the user does not own it' do
    user = FactoryGirl.create(:user)
    guide = FactoryGirl.create(:guide)
    sign_in user

    expect do
      delete 'destroy', id: guide.id
    end.to raise_exception(OpenfarmErrors::NotAuthorized)
  end

  it 'shows a 404 on DocumentNotFound' do
    get 'show', id: '1'
    expect(response).to render_template(file: "#{Rails.root}/public/404.html")
  end
end
