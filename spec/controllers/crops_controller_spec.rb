require 'spec_helper'
require 'uri'

describe CropsController, :type => :controller do
  it 'Should direct to a new page' do
    user = FactoryBot.create(:user)
    sign_in user
    get 'new'
    expect(response).to render_template(:new)
    expect(response.status).to eq(200)
  end

  it 'Should redirect to crop_searches' do
    get 'index'
    expect(response).to redirect_to controller: 'crop_searches', action: 'search'
    expect(response.status).to eq(302)
  end

  it 'Should render a show page' do
    crop = FactoryBot.create(:crop)
    get 'show', id: crop.id
    expect(response).to render_template(:show)
    expect(response.status).to eq(200)
  end

  it 'Should direct to view crop page after successful crop creation' do
    crop = FactoryBot.attributes_for(:crop)
    user = FactoryBot.create(:user)
    sign_in user
    post 'create', crop: crop
    expect(response.status).to eq(302)
    expect(response).to redirect_to crop_path(:en, id: assigns(:crop).id)
  end

  it 'should redirect to create guide page when source is guide page' do
    crop = FactoryBot.attributes_for(:crop)
    user = FactoryBot.create(:user)
    sign_in user
    crop.update(source: 'guide')
    post 'create', crop: crop
    expect(response.status).to eq(302)
    expect(response).to redirect_to new_guide_path(:en,
                                                   crop_id: assigns(:crop).id)
  end

  it 'Should redirect back to form after unsuccessful crop creation' do
    crop = FactoryBot.attributes_for(:crop)
    user = FactoryBot.create(:user)
    sign_in user
    crop[:name] = ""
    post 'create', crop: crop
    expect(response).to render_template(:new)
    expect(response.status).to eq(200)
  end

  it 'should render an edit page if the user is logged in' do
    user = FactoryBot.create(:user)
    sign_in user
    crop = FactoryBot.create(:crop)
    get 'edit', id: crop.id
    expect(response).to render_template(:edit)
    expect(response.status).to eq(200)
  end

  it 'should rerender the edit page if not all params are good' do
    crop = FactoryBot.create(:crop)
    user = FactoryBot.create(:user, admin: true)
    sign_in user
    initial_name = crop.name
    put 'update',
        id: crop.id,
        attributes: { name: '' }
    expect(crop.reload.name).to eq(initial_name)
    expect(response.status).to eq(200)
  end

  it 'puts successful updates to a crop' do
    crop = FactoryBot.create(:crop)
    user = FactoryBot.create(:user, admin: true)
    sign_in user
    put 'update',
        id: crop.id,
        attributes: { name: 'Updated name' }
    expect(crop.reload.name).to eq('Updated name')
    expect(response.status).to eq(302)
  end

  it 'should give current_user a badge for creating a crop' do
    user = FactoryBot.create(:user)
    sign_in user

    crop = FactoryBot.attributes_for(:crop)
    post 'create', crop: crop
    user.reload

    assert user.badges.count == 1
    assert user.badges.first.name == 'crop-creator'
  end

  it 'should give current_user a badge for editing a crop' do
    user = FactoryBot.create(:user)
    sign_in user

    crop = FactoryBot.create(:crop)
    put 'update',
        id: crop.id,
        attributes: { name: 'Updated name' }
    user.reload

    assert user.badges.count == 1
    assert user.badges.first.name == 'crop-editor'
  end
end
