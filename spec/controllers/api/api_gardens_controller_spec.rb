require 'spec_helper'

describe Api::GardensController, type: :controller do
  include ApiHelpers

  describe 'index' do
    before do
      @viewing_user = FactoryGirl.create :user
      @other_user = FactoryGirl.create :user
      sign_in @viewing_user
    end

    # These are not yet implemented because index is
    # funny about nested things.
    it 'should show non private gardens and gardens belonging to a user'

    it 'should show all gardens if the user is admin'
  end

  describe 'show' do
    before do
      @viewing_user = FactoryGirl.create :user
      @other_user = FactoryGirl.create :user
      sign_in @viewing_user
    end

    it 'should show admins gardens regardless of privacy setting' do
      @viewing_user.admin = true
      @viewing_user.save
      public_garden = FactoryGirl.create(:garden,
                                         user: @other_user)
      private_garden = FactoryGirl.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(public_garden.name)
      get 'show', id: private_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(private_garden.name)
    end

    it 'should shown not signed in users only public gardens' do
      sign_out @viewing_user
      public_garden = FactoryGirl.create(:garden,
                                         user: @other_user)
      private_garden = FactoryGirl.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(public_garden.name)
      get 'show', id: private_garden.id
      expect(response.status).to eq(401)
    end

    it 'should not show private gardens to ordinary users' do
      public_garden = FactoryGirl.create(:garden,
                                         user: @other_user)
      private_garden = FactoryGirl.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(public_garden.name)
      get 'show', id: private_garden.id
      expect(response.status).to eq(401)
    end

    it 'should show the user their private and public gardens' do
      public_garden = FactoryGirl.create(:garden,
                                         user: @viewing_user)
      private_garden = FactoryGirl.create(:garden,
                                          user: @viewing_user,
                                          is_private: true)
      get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(public_garden.name)
      get 'show', id: private_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(private_garden.name)
    end
  end

  describe 'update' do
    before do
      @viewing_user = FactoryGirl.create :user
      sign_in @viewing_user
    end

    it 'should not allow editing of non-owned gardens' do
      garden = FactoryGirl.create(:garden)
      put :update,
          id: garden.id,
          garden: {
            name: 'updated'
          },
          format: :json

      expect(response.status).to eq(422)
      expect(response.body).to include('only update gardens that belong to you')
    end

    it 'should edit owned gardens' do
      garden = FactoryGirl.create(:garden, user: @viewing_user)
      put :update,
          id: garden.id,
          garden: {
            name: 'updated'
          },
          format: :json
      expect(response.status).to eq(200)
      expect(garden.reload.name).to eq('updated')
    end
  end
end
