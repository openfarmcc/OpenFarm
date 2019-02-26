require 'spec_helper'

describe Api::V1::GardenCropsController, type: :controller do
  include ApiHelpers

  describe 'create' do
    before do
      @user = FactoryBot.create :user
      sign_in @user
    end

    it 'should create garden crops' do
      guide = FactoryBot.create(:guide)
      garden = FactoryBot.create(:garden, user: @user)
      sowed = "#{Faker::Date.between(2.days.ago, Date.today)}"
      data = { attributes: { quantity: rand(100),
                             stage: "#{Faker::Lorem.word}",
                             sowed: sowed,
                             guide: guide.id.to_s } }

      old_length = garden.garden_crops.length
      Legacy._post :create, data: data, garden_id: garden.id.to_s, format: :json
      new_length = garden.reload.garden_crops.length
      expect(response.status).to eq(201)
      expect(new_length).to eq(old_length + 1)
    end

    it 'should give the user a gardener badge on adding a garden crop' do
      guide = FactoryBot.create(:guide)
      garden = FactoryBot.create(:garden, user: @user)
      sowed = "#{Faker::Date.between(2.days.ago, Date.today)}"
      data = { attributes: { quantity: rand(100),
                             stage: "#{Faker::Lorem.word}",
                             sowed: sowed,
                             guide: guide.id.to_s } }

      Legacy._post :create, data: data, garden_id: garden.id.to_s, format: :json
      @user.reload
      assert @user.badges.last.name == 'gardener'
    end

    it 'should not allow user to add garden crops to other user gardens' do
      guide = FactoryBot.create(:guide)
      garden = FactoryBot.create(:garden)
      sowed = "#{Faker::Date.between(2.days.ago, Date.today)}"
      data = { attributes: { quantity: rand(100),
                             stage: "#{Faker::Lorem.word}",
                             sowed: sowed,
                             guide: guide.id.to_s,
                            } }
      Legacy._post :create, data: data, garden_id: garden.id.to_s, format: :json
      expect(response.status).to eq(422)
    end
  end

  describe 'destroy' do
    before do
      @user = FactoryBot.create :user
      sign_in @user
    end

    it 'should delete garden crops' do
      garden = FactoryBot.create(:garden, user: @user)
      garden_crop = FactoryBot.create(:garden_crop, garden: garden)
      Legacy._delete :destroy,
             garden_id: garden_crop.garden.id,
             id: garden_crop.id,
             format: :json
      expect(garden.reload.garden_crops.length).to eq(0)
      expect(response.status).to eq(204)
    end

    it 'should not delete garden crops of other users gardens' do
      garden_crop = FactoryBot.create(:garden_crop)
      Legacy._delete :destroy,
             garden_id: garden_crop.garden.id.to_s,
             id: garden_crop.id,
             format: :json
      expect(response.status).to eq(401)
    end

    it 'should handle deletion of unknown garden crops' do
      garden = FactoryBot.create(:garden, user: @user)
      Legacy._delete :destroy, garden_id: garden.id.to_s, id: 1
      expect(response.status).to eq(422)
    end
  end

  describe 'index' do
    before do
      @user = FactoryBot.create :user
      sign_in @user
    end
    it 'should show garden crops for a specific garden' do
      garden = FactoryBot.create(:garden, user: @user)
      FactoryBot.create(:garden_crop, garden: garden)

      Legacy._get self, :index, garden_id: garden.id

      expect(json['data'].length).to eq(1)
      expect(response.status).to eq(200)
    end

    it 'should not show garden crops for a private garden' do
      garden = FactoryBot.create(:garden, is_private: true)
      FactoryBot.create(:garden_crop, garden: garden)

      Legacy._get self, :index, garden_id: garden.id

      expect(response.status).to eq(401)
    end

    it 'should return a not found error for non-existent garden' do
      Legacy._get self, :index, garden_id: 1
      expect(response.status).to eq(404)
    end
  end

  describe 'show' do
    before do
      @user = FactoryBot.create :user
      sign_in @user
      @garden = FactoryBot.create(:garden, user: @user)
    end

    it 'should return a not found error for non-existent garden' do
      Legacy._get self, :show, garden_id: 1, id: 1
      expect(response.status).to eq(404)
    end

    it 'should return a not found error for non-existent garden crops' do
      Legacy._get self, :show, garden_id: @garden.id, id: 1
      expect(response.status).to eq(404)
    end

    it 'should show a garden_crop with a crop' do
      crop = FactoryBot.create :crop
      garden_crop = FactoryBot.create(:garden_crop,
                                       garden: @garden,
                                       crop: crop)
      # @garden.crop = FactoryBot.create :crop
      garden_crop.save
      Legacy._get self, :show, garden_id: @garden.id, id: garden_crop.id
      expect(json['data']['attributes']['crop']['name']).to eq(crop.name)
    end

    it 'should show a garden_crop with a guide' do
      guide = FactoryBot.create :guide
      garden_crop = FactoryBot.create(:garden_crop,
                                       garden: @garden,
                                       guide: guide)
      # @garden.crop = FactoryBot.create :crop
      garden_crop.save
      Legacy._get self, :show, garden_id: @garden.id, id: garden_crop.id
      expect(json['data']['attributes']['guide']['name']).to eq(guide.name)
    end

    it 'should show a garden crop that exists' do
      garden_crop = FactoryBot.create(:garden_crop, garden: @garden)
      Legacy._get self, :show, garden_id: garden_crop.garden.id, id: garden_crop.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['quantity']).to eq(garden_crop.quantity)
    end

    it 'should not show garden crops that belong to a private garden' do
      garden = FactoryBot.create(:garden, is_private: true)
      garden_crop = FactoryBot.create(:garden_crop, garden: garden)
      Legacy._get self, :show, garden_id: garden_crop.garden.id, id: garden_crop.id
      expect(response.status).to eq(401)
    end

    it 'should show private garden crops to admin' do
      admin = FactoryBot.create :user, admin: true
      sign_in admin
      garden = FactoryBot.create(:garden, is_private: true)
      garden_crop = FactoryBot.create(:garden_crop, garden: garden)

      Legacy._get self, :show, garden_id: garden_crop.garden.id, id: garden_crop.id

      expect(response.status).to eq(200)
      expect(json['data']['attributes']['quantity']).to eq(garden_crop.quantity)
    end
  end

  describe 'update' do
    it 'should update a garden crop' do
      user = FactoryBot.create(:user)
      sign_in user
      garden = FactoryBot.create(:garden, user: user)
      garden_crop = FactoryBot.create(:garden_crop, garden: garden)
      Legacy._put :update,
          garden_id: garden_crop.garden.id,
          id: garden_crop.id,
          data: { attributes: { stage: 'updated' } },
          format: :json
      expect(response.status).to eq(200)
      expect(garden_crop.reload.stage).to eq('updated')
    end
    it 'should not update garden crops belonging to other users' do
      garden_crop = FactoryBot.create(:garden_crop)
      Legacy._put :update,
          garden_id: garden_crop.garden.id,
          id: garden_crop.id,
          data: { attributes: { stage: 'updated' } },
          format: :json
      expect(response.status).to eq(401)
    end
  end
end
