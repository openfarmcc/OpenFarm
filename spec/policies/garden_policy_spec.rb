require 'spec_helper'

describe GardenPolicy do
  subject { GardenPolicy }

  let (:current_user) { FactoryGirl.create :user }
  let (:public_garden) { FactoryGirl.create :garden }
  let (:private_garden) { FactoryGirl.create :garden, is_private: true }
  let (:admin) { FactoryGirl.create :user, admin: true }

  permissions :show? do
    it 'denies access if garden is private' do
      expect(GardenPolicy).not_to permit(current_user, private_garden)
    end

    it 'grants access if garden is private and current_user is admin' do
      expect(GardenPolicy).to permit(admin, private_garden)
    end

    it 'grants access if garden is public and user is nil' do
      expect(GardenPolicy).to permit(nil, public_garden)
    end

    it 'grants access if garden is private and belongs to current user' do
      private_garden.user = current_user
      private_garden.save
      expect(GardenPolicy).to permit(current_user, private_garden)
    end
  end

  context 'for a user' do
    it 'should only return gardens in scope that are public' do
      Garden.destroy_all
      other_user = FactoryGirl.create :user
      not_mine = FactoryGirl.create :garden,
                                    is_private: true,
                                    name: 'not_mine',
                                    user: other_user
      shared = FactoryGirl.create :garden,
                                  is_private: false,
                                  name: 'yes!',
                                  user: other_user
      @p = GardenPolicy::Scope.new(current_user, Garden).resolve
      expect(@p).not_to include(not_mine)
      expect(@p).to     include(shared)
    end

    it 'should only return public gardens unless they are current_user' do
      Garden.destroy_all
      other_user = FactoryGirl.create :user
      mine = FactoryGirl.create :garden,
                                is_private: true,
                                name: 'mine',
                                user: current_user
      publicly_shared = FactoryGirl.create :garden,
                                            is_private: false,
                                            name: 'not mine but OK (public)',
                                            user: other_user
      not_mine = FactoryGirl.create :garden,
                                    is_private: true,
                                    name: 'not mine',
                                    user: other_user
      @p = GardenPolicy::Scope.new(current_user, Garden).resolve
      expect(@p).to include(mine)
      expect(@p).to include(publicly_shared)
      expect(@p).not_to include(not_mine)
    end

    it 'should return all gardens in scope when user is admin' do
      Garden.destroy_all
      a = FactoryGirl.create :garden,
                             is_private: true,
                             name: 'nono',
                             user: current_user
      b = FactoryGirl.create :garden,
                             is_private: false,
                             name: 'yes!',
                             user: current_user
      @p = GardenPolicy::Scope.new(admin, Garden).resolve
      expect(@p).to include(a)
      expect(@p).to include(b)
      expect(@p.length).to eq(Garden.count)
    end
  end
end
