require 'spec_helper'

describe Api::GardenCropsController, type: :controller do
  include ApiHelpers

  describe 'create' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
    end

    it 'should create garden crops' do
      guide = FactoryGirl.create(:guide)
      garden = FactoryGirl.create(:garden, user: @user)
      data = { quantity: rand(100),
               stage: "#{Faker::Lorem.word}",
               sowed: "#{Faker::Date.between(2.days.ago, Date.today)}",
               guide_id: guide.id,
               garden_id: garden.id }
      old_length = garden.garden_crops.length
      post :create, data, format: :json
      new_length = garden.reload.garden_crops.length
      expect(response.status).to eq(201)
      expect(new_length).to eq(old_length + 1)
    end

    it 'should not allow user to add garden crops to other user gardens' do
      guide = FactoryGirl.create(:guide)
      garden = FactoryGirl.create(:garden)
      data = { quantity: rand(100),
               stage: "#{Faker::Lorem.word}",
               sowed: "#{Faker::Date.between(2.days.ago, Date.today)}",
               guide_id: guide.id,
               garden_id: garden.id }
      post :create, data, format: :json
      expect(response.status).to eq(422)
    end
  end

  describe 'destroy' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
    end

    it 'should delete garden crops' do
      garden = FactoryGirl.create(:garden, user: @user)
      garden_crop = FactoryGirl.create(:garden_crop, garden: garden)
      delete :destroy,
             garden_id: garden_crop.garden.id,
             id: garden_crop.id,
             format: :json
      expect(garden.reload.garden_crops.length).to eq(0)
      expect(response.status).to eq(204)
    end

    it 'should not delete garden crops of other users gardens' do
      garden_crop = FactoryGirl.create(:garden_crop)
      delete :destroy,
             garden_id: garden_crop.garden.id,
             id: garden_crop.id,
             format: :json
      expect(response.status).to eq(401)
    end

    it 'should handle deletion of unknown garden crops' do
      garden = FactoryGirl.create(:garden, user: @user)
      delete :destroy, garden_id: garden.id, id: 1
      expect(response.status).to eq(422)
    end
  end

  describe 'index' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
    end
    it 'should show garden crops for a specific garden' do
      garden = FactoryGirl.create(:garden, user: @user)
      FactoryGirl.create(:garden_crop, garden: garden)

      get :index, garden_id: garden.id

      expect(json['garden_crops'].length).to eq(1)
      expect(response.status).to eq(200)
    end

    it 'should not show garden crops for a private garden' do
      garden = FactoryGirl.create(:garden, is_private: true)
      FactoryGirl.create(:garden_crop, garden: garden)

      get :index, garden_id: garden.id

      expect(response.status).to eq(401)
    end

    it 'should return a not found error for non-existent garden' do
      get :index, garden_id: 1
      expect(response.status).to eq(404)
    end
  end

  describe 'show' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      @garden = FactoryGirl.create(:garden, user: @user)
    end

    it 'should return a not found error for non-existent garden' do
      get :show, garden_id: 1, id: 1
      expect(response.status).to eq(404)
    end

    it 'should return a not found error for non-existent garden crops' do
      get :show, garden_id: @garden.id, id: 1
      expect(response.status).to eq(404)
    end

    it 'should show a garden crop that exists' do
      garden_crop = FactoryGirl.create(:garden_crop, garden: @garden)
      get :show, garden_id: garden_crop.garden.id, id: garden_crop.id
      expect(response.status).to eq(200)
      expect(json['garden_crop']['quantity']).to eq(garden_crop.quantity)
    end

    it 'should not show garden crops that belong to a private garden' do
      garden = FactoryGirl.create(:garden, is_private: true)
      garden_crop = FactoryGirl.create(:garden_crop, garden: garden)
      get :show, garden_id: garden_crop.garden.id, id: garden_crop.id
      expect(response.status).to eq(401)
    end

    it 'should show private garden crops to admin' do
      admin = FactoryGirl.create :user, admin: true
      sign_in admin
      garden = FactoryGirl.create(:garden, is_private: true)
      garden_crop = FactoryGirl.create(:garden_crop, garden: garden)

      get :show, garden_id: garden_crop.garden.id, id: garden_crop.id

      expect(response.status).to eq(200)
      expect(json['garden_crop']['quantity']).to eq(garden_crop.quantity)
    end
  end

  describe 'update' do
    it 'should update a garden crop' do
      user = FactoryGirl.create(:user)
      sign_in user
      garden = FactoryGirl.create(:garden, user: user)
      garden_crop = FactoryGirl.create(:garden_crop, garden: garden)
      put :update,
          garden_id: garden_crop.garden.id,
          id: garden_crop.id,
          stage: 'updated',
          format: :json
      expect(response.status).to eq(200)
      expect(garden_crop.reload.stage).to eq('updated')
    end
    it 'should not update garden crops belonging to other users' do
      garden_crop = FactoryGirl.create(:garden_crop)
      put :update,
          garden_id: garden_crop.garden.id,
          id: garden_crop.id,
          stage: 'updated',
          format: :json
      expect(response.status).to eq(401)
    end
  end
end
