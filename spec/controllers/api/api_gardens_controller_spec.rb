require 'spec_helper'

describe Api::V1::GardensController, type: :controller do
  include ApiHelpers

  describe 'index' do
    before do
      @viewing_user = FactoryBot.create :confirmed_user
      @other_user = FactoryBot.create :confirmed_user
      sign_in @viewing_user
    end

    # These are not yet implemented because index is
    # funny about nested things.
    it 'should show non private gardens and gardens belonging to a user'

    it 'should show all gardens if the user is admin'
  end

  describe 'show' do
    before do
      @viewing_user = FactoryBot.create :confirmed_user
      @other_user = FactoryBot.create :confirmed_user
      sign_in @viewing_user
    end

    it 'should show admins gardens regardless of privacy setting' do
      @viewing_user.admin = true
      @viewing_user.save
      public_garden = FactoryBot.create(:garden,
                                         user: @other_user)
      private_garden = FactoryBot.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      Legacy._get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(public_garden.name)
      Legacy._get 'show', id: private_garden.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(private_garden.name)
    end

    it 'should shown not signed in users only public gardens' do
      sign_out @viewing_user
      public_garden = FactoryBot.create(:garden,
                                         user: @other_user)
      private_garden = FactoryBot.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      Legacy._get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(public_garden.name)
      Legacy._get 'show', id: private_garden.id
      expect(response.status).to eq(401)
    end

    it 'should not show private gardens to ordinary users' do
      public_garden = FactoryBot.create(:garden,
                                         user: @other_user)
      private_garden = FactoryBot.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      Legacy._get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(public_garden.name)
      Legacy._get 'show', id: private_garden.id
      expect(response.status).to eq(401)
    end

    it 'should show the user their private and public gardens' do
      public_garden = FactoryBot.create(:garden,
                                         user: @viewing_user)
      private_garden = FactoryBot.create(:garden,
                                          user: @viewing_user,
                                          is_private: true)
      Legacy._get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(public_garden.name)
      Legacy._get 'show', id: private_garden.id
      expect(response.status).to eq(200)
      expect(json['data']['attributes']['name']).to eq(private_garden.name)
    end
  end

  describe 'create' do
    before do
      @viewing_user = FactoryBot.create :confirmed_user
      sign_in @viewing_user
    end

    it 'should create a garden' do
      Legacy._post :create,
           data: { attributes: { name: 'New Garden' } },
           format: :json
      expect(response.status).to eq(201)
      expect(Garden.all.last.name).to eq('New Garden')
    end

    it 'should prevent non-logged in users from creating a garden'

    it 'should give garden-creator badge when user creates a second garden' do
      assert @viewing_user.badges.empty?
      data = { attributes: { name: 'Second Garden' } }
      Legacy._post :create,
           data: data,
           format: :json
      @viewing_user.reload
      assert @viewing_user.badges.count == 1
    end
  end

  describe 'update' do
    before do
      @viewing_user = FactoryBot.create :user
      sign_in @viewing_user
    end

    it 'should not allow editing of non-owned gardens' do
      garden = FactoryBot.create(:garden)
      Legacy._put :update,
          id: garden.id.to_s,
          data: { attributes: { name: 'updated' } },
          format: :json

      expect(response.status).to eq(422)
      expect(response.body).to include('only update gardens that belong to you')
    end

    it 'should edit owned gardens' do
      garden = FactoryBot.create(:garden, user: @viewing_user)
      Legacy._put :update,
          id: garden.id.to_s,
          data: { attributes: { name: 'updated' } },
          format: :json
      expect(response.status).to eq(200)
      expect(garden.reload.name).to eq('updated')
    end
  end

  describe 'destroy' do
    let(:user) { FactoryBot.create(:user) }

    it 'deletes gardens' do
      garden = FactoryBot.create(:garden, user: user)
      sign_in user
      old_length = Garden.all.length
      Legacy._delete :destroy, id: garden.id, format: :json
      new_length = Garden.all.length
      expect(new_length).to eq(old_length - 1)
    end

    it 'returns an error when a garden does not exist' do
      sign_in user
      Legacy._delete :destroy, id: 1, format: :json
      expect(json['errors'][0]['title']).to include(
        'Could not find a garden with id')
      expect(response.status).to eq(422)
    end

    it 'only destroys gardens owned by the user' do
      sign_in user
      Legacy._delete :destroy, id: FactoryBot.create(:garden)
      expect(json['errors'][0]['title']).to include(
        'can only destroy gardens that belong to you.')
      expect(response.status).to eq(401)
    end
  end
end
