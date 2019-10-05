# frozen_string_literal: true

require 'spec_helper'
require 'openfarm_errors'

describe GuidesController do
  it 'directs to a new page' do
    user = FactoryBot.create(:user)
    sign_in user
    Legacy._get self, 'new'
    expect(response).to render_template(:new)
    expect(response.status).to eq(200)
  end

  it 'renders a show page' do
    guide = FactoryBot.create(:guide)
    Legacy._get self, 'show', id: guide.id
    expect(response).to render_template(:show)
    expect(response.status).to eq(200)
  end

  it 'should show the edit page if the user owns the guide' do
    guide = FactoryBot.create(:guide)
    user = guide.user
    sign_in user
    Legacy._get self, 'edit', id: guide.id
    expect(response).to redirect_to guide_path(:en, guide)
    expect(response.status).to eq(302)
  end

  it 'should redirect to the guide if the user does not own it' do
    guide = FactoryBot.create(:guide)
    user = FactoryBot.create(:user)
    sign_in user
    Legacy._get self, 'edit', id: guide.id
    expect(response).to redirect_to guide_path(:en, guide)
    expect(response.status).to eq(302)
  end

  it 'should access logged in user profile page when accessing index' do
    user = FactoryBot.create(:user)
    sign_in user
    get 'index'
    expect(response).to redirect_to user_path(:en, user)
    expect(response.status).to eq(302)
  end

  it 'should access root page when accessing index not logged in' do
    Legacy._get self, 'index'
    expect(response).to redirect_to root_path(:en)
    expect(response.status).to eq(302)
  end

  it 'should delete a guide' do
    user = FactoryBot.create(:user)
    guide = FactoryBot.create(:guide, user: user)
    sign_in user
    Legacy._delete self, 'destroy', id: guide.id

    expect(response.status).to eq(302)
  end

  it 'should not delete a guide if the user does not own it' do
    user = FactoryBot.create(:user)
    guide = FactoryBot.create(:guide)
    sign_in user

    expect { Legacy._delete self, 'destroy', id: guide.id }.to raise_exception(OpenfarmErrors::NotAuthorized)
  end

  it 'shows a 404 on DocumentNotFound' do
    Legacy._get self, 'show', id: '1'
    expect(response).to render_template(file: "#{Rails.root}/public/404.html")
  end
end
