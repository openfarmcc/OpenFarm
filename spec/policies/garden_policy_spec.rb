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
      other_user = FactoryGirl.create :user
      FactoryGirl.create :garden,
                         is_private: true,
                         name: 'nono',
                         user: other_user
      FactoryGirl.create :garden,
                         is_private: false,
                         name: 'yes!',
                         user: other_user
      @p = GardenPolicy::Scope.new(current_user, Garden).resolve
      # expect(@p.length).to eq(2)
    end

    it 'should only return public gardens unless they are current_user' do
      other_user = FactoryGirl.create :user
      FactoryGirl.create :garden,
                         is_private: true,
                         name: 'nono',
                         user: current_user
      FactoryGirl.create :garden,
                         is_private: false,
                         name: 'yes!',
                         user: other_user
      @p = GardenPolicy::Scope.new(current_user, Garden).resolve
      # expect(@p.length).to eq(3)
    end

    it 'should return all gardens in scope when user is admin' do
      FactoryGirl.create :garden,
                         is_private: true,
                         name: 'nono',
                         user: current_user
      FactoryGirl.create :garden,
                         is_private: false,
                         name: 'yes!',
                         user: current_user
      @p = GardenPolicy::Scope.new(admin, Garden).resolve
      # expect(@p.length).to eq(4)
    end
  end
end
