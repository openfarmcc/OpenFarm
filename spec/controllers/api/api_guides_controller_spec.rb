require 'spec_helper'

describe Api::V1::GuidesController, type: :controller do
  include ApiHelpers

  let(:user) { sign_in(user = FactoryBot.create(:user)) && user }
  let(:guide) { FactoryBot.create(:guide, user: user) }

  before do
    @beans_v2 = FactoryBot.create(:guide, name: 'lee\'s mung bean')
    FactoryBot.create_list(:guide, 2)
  end

  describe 'create' do
    it 'create guides' do
      sign_in FactoryBot.create(:user)
      old_length = Guide.all.length
      crop = FactoryBot.create(:crop)
      data = { attributes: { name: 'brocolini in the desert',
                             overview: 'something exotic' },
               crop_id: crop.id.to_s
             }
      Legacy.post 'create', data: data, format: :json
      expect(response.status).to eq(201)
      expect(json['data']['attributes']['name']).to eq(data[:attributes][:name])

      expect(Guide.last.crop.id.to_s).to eq(data[:crop_id])

      expect(Guide.all.length).to eq(old_length + 1)
    end

    it 'creates a crop if no crop was found' do
      skip 'Fails on CI: skipping - RickCarlino'
      sign_in FactoryBot.create(:user)
      original_length = Crop.all.length
      data = { attributes: { name: 'brocolini in the desert',
                             overview: 'something exotic' },
               crop_id: nil,
               crop_name: 'Test Crop' }
      Legacy.post 'create', data: data, format: :json
      expect(response.status).to eq(201)
      expect(Crop.all.length).to eq(original_length + 1)
    end

    it 'finds a crop if no crop was found on the frontend, but does exist' do
      skip 'Fails on CI: skipping - RickCarlino'
      sign_in FactoryBot.create(:user)
      crop = FactoryBot.create(:crop, name: 'Terra Plant')
      Crop.reindex
      original_length = Crop.all.length
      data = { attributes: { name: 'brocolini in the desert',
                             overview: 'something exotic' },
               crop_id: nil,
               crop_name: crop.name }
      Legacy.post 'create', data: data, format: :json
      expect(response.status).to eq(201)
      expect(Crop.all.length).to eq(original_length)
      expect(Guide.last.crop.id).to eq(crop.id)
    end

    it 'create guide should return an error when wrong info is passed' do
      sign_in FactoryBot.create(:user)
      data = { attributes: { overview: 'A tiny pixel test image.' },
               crop_id: FactoryBot.create(:crop).id.to_s }
      Legacy.post 'create', data: data
      expect(response.status).to eq(422)
    end

    it 'uploads a featured_image' do
      params = { attributes: { name: 'Just 1 pixel.',
                               overview: 'A tiny pixel test image.' },
                 images: [{ image_url: 'http://placehold.it/1x1.jpg' }],
                 crop_id: FactoryBot.create(:crop).id.to_s }
      sign_in FactoryBot.create(:user)
      VCR.use_cassette('controllers/api/api_guides_controller_spec') do
        Legacy.post 'create', data: params
      end
      expect(response.status).to eq(201)
      img_url = json['data']['attributes']['featured_image']['image_url']
      expect(img_url).to include('/system/')
    end

    it 'should give current_user a badge for creating a guide' do
      sign_in user

      assert user.badges.empty?

      data = { attributes: { name: 'brocolini in the desert',
                             overview: 'something exotic' },
               crop_id: FactoryBot.create(:crop).id.to_s }
      Legacy.post 'create', data: data, format: :json
      expect(response.status).to eq(201)
      user.reload

      assert user.badges.count == 1

      assert user.badges.first.name == 'guide-creator'
    end
  end

  describe 'show' do
    it 'should show a specific guide' do
      guide = FactoryBot.create(:guide)
      Legacy.get 'show', id: guide.id, format: :json
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(guide.name)
    end
  end

  describe 'update' do

    it 'should update a guide' do
      sign_in user
      guide = FactoryBot.create(:guide, user: user, overview: 'old')
      params = { attributes: { overview: 'updated' } }
      put 'update', id: guide.id, data: params
      expect(response.status).to eq(200)
      guide.reload
      expect(guide.overview).to eq('updated')
    end

    it 'should not update someone elses guide' do
      sign_in FactoryBot.create(:user)
      guide = FactoryBot.create(:guide)
      put :update, id: guide.id, data: { attributes: { overview: 'updated' } }
      expect(response.status).to eq(401)
      expect(response.body).to include('only modify guides that you created')
    end

    it 'validates URL paramters' do
      data = { attributes: {}, images: [{ image_url: 'not a real URL' }] }
      put :update, id: guide.id, data: data
      expect(response.status).to eq(422)
      expect(json['errors'][0]['title']).to include('not a valid URL')
    end
  end

  describe 'destroy' do
    it 'deletes guides' do
      garden = FactoryBot.create(:guide, user: user)
      sign_in user
      old_length = Guide.all.length
      Legacy.delete :destroy, id: garden.id, format: :json
      new_length = Guide.all.length
      expect(new_length).to eq(old_length - 1)
    end

    it 'returns an error when a guide does not exist' do
      sign_in user
      Legacy.delete :destroy, id: 1, format: :json
      expect(json['errors'][0]['title']).to include(
        'Could not find a guide with id')
      expect(response.status).to eq(422)
    end

    it 'only destroys guides owned by the user' do
      sign_in user
      Legacy.delete :destroy, id: FactoryBot.create(:guide)
      expect(json['errors'][0]['title']).to include(
        'can only destroy guides that belong to you.')
      expect(response.status).to eq(401)
    end
  end
end
