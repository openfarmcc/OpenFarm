require 'spec_helper'

describe Api::UsersController, type: :controller do
  include ApiHelpers

  let(:viewing_user) { FactoryGirl.create(:confirmed_user) }
  let(:public_user) { FactoryGirl.create(:confirmed_user) }
  let(:private_user) { FactoryGirl.create(:confirmed_user, is_private: true) }

  it 'shows private user to an admin' do
    viewing_user.admin = true
    viewing_user.save
    sign_in viewing_user
    get 'show', id: private_user.id, format: :json
    expect(response.status).to eq(200)
    expect(json.length).to eq(1)
    expect(json['user']).to have_key('user_setting')
  end

  it 'does not show private user to an ordinary user' do
    sign_in viewing_user
    get 'show', id: private_user.id, format: :json
    expect(response.status).to eq(401)
  end

  it 'shows public users to a user' do
    viewing_user.save
    sign_in viewing_user
    get 'show', id: public_user.id, format: :json
    expect(response.status).to eq(200)
    expect(json['user']).to have_key('user_setting')
  end

  it 'shows basics to non-logged in users' do
    get 'show', id: public_user.id, format: :json
    expect(response.status).to eq(200)
    expect(json['user']).to_not have_key('user_setting')
  end

  it 'shows a favorite crop for a user' do
    crop = FactoryGirl.create(:crop)
    public_user.user_setting.favorite_crops = [crop]
    public_user.user_setting.save
    sign_in viewing_user
    get 'show', id: public_user.id, format: :json
    expect(response.status).to eq(200)
    expect(json['user']['user_setting']).to have_key('favorite_crop')
  end

  it 'shows a favorite crop with images for a user' do
    VCR.use_cassette('controllers/api/api_users_controller_spec') do
      crop = FactoryGirl.create(:crop)

      crop.pictures = [FactoryGirl.create(:crop_picture)]
      crop.save

      public_user.user_setting.favorite_crops = [crop]
      public_user.user_setting.save
      sign_in viewing_user

      get 'show', id: public_user.id, format: :json

      expect(json['user']['user_setting']).to have_key('favorite_crop')
      fav_crop = json['user']['user_setting']['favorite_crop']
      expect(fav_crop).to have_key('image_url')
    end
  end

  it 'adds a featured image' do
    VCR.use_cassette('controllers/api/api_users_controller_spec') do
      public_user.user_setting.picture = FactoryGirl.create(:user_picture)
      public_user.user_setting.save
      sign_in viewing_user
      get 'show', id: public_user.id, format: :json
      expect(json['user']['user_setting']).to have_key('picture')
      # cat.jpg is the name created in the factorygirl for user_picture
      # (fixture file)
      pic_json = json['user']['user_setting']['picture']
      expect(pic_json['image_url']).to include('cat.jpg')
    end
  end
end
