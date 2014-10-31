require 'spec_helper'

describe Api::GardensController, type: :controller do
  include ApiHelpers

  describe 'index' do
    before do
      @viewing_user = FactoryGirl.create :user
      @other_user = FactoryGirl.create :user
      sign_in @viewing_user
    end
    it 'should show non private gardens and gardens belonging to a user' do
      FactoryGirl.create(:garden, user: @other_user)
      FactoryGirl.create(:garden, user: @viewing_user, is_private: true)
      FactoryGirl.create(:garden, user: @other_user, is_private: true)
      private_length = Garden.or(
        { is_private: false },
        { user: @viewing_user }
      ).length
      get 'index'
      expect(response.status).to eq(200)
      expect(json['gardens'].length).to eq(private_length)
    end

    it 'should show all gardens if the user is admin' do
      @viewing_user.admin = true
      @viewing_user.save
      FactoryGirl.create :garden, user: @other_user
      FactoryGirl.create :garden, user: @other_user, is_private: true
      get 'index'
      expect(response.status).to eq(200)
      expect(json['gardens'].length).to eq(Garden.all.length)
    end
  end

  describe 'show' do
    before do
      @viewing_user = FactoryGirl.create :user
      @other_user = FactoryGirl.create :user
      sign_in @viewing_user
    end
    it 'should show admins all gardens' do
      @viewing_user.admin = true
      @viewing_user.save
      public_garden = FactoryGirl.create(:garden,
                                         user: @other_user)
      private_garden = FactoryGirl.create(:garden,
                                          user: @other_user,
                                          is_private: true)
      get 'show', id: public_garden.id
      expect(response.status).to eq(200)
      puts json
      expect(json['garden']['name']).to eq(public_garden.name)
      get 'show', id: private_garden.id
      expect(response.status).to eq(200)
      expect(json['garden']['name']).to eq(private_garden.name)
    end

    # it 'should not show private gardens to ordinary users' do
    #   public_garden = FactoryGirl.create(:garden,
    #                                      user: @other_user)
    #   private_garden = FactoryGirl.create(:garden,
    #                                       user: @other_user,
    #                                       is_private: true)
    #   get 'show', id: public_garden.id
    #   expect(response.status).to eq(200)
    #   expect(json['garden']['name']).to eq(public_garden.name)
    #   get 'show', id: private_garden.id
    #   expect(response.status).to eq(400)
    # end

    # it 'should show the user their private and public gardens' do
    #   public_garden = FactoryGirl.create(:garden,
    #                                      user: @viewing_user)
    #   private_garden = FactoryGirl.create(:garden,
    #                                       user: @viewing_user,
    #                                       is_private: true)
    #   get 'show', id: public_garden.id
    #   expect(response.status).to eq(200)
    #   expect(json['garden']['name']).to eq(public_garden.name)
    #   get 'show', id: private_garden.id
    #   expect(response.status).to eq(200)
    #   expect(json['garden']['name']).to eq(private_garden.name)
    # end
  end
end
