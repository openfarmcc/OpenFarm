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
      Garden.create(user: other_user,
                    name: 'haha',
                    is_private: false)
      Garden.create(user: other_user,
                    name: 'nono',
                    is_private: true)
      @p = GardenPolicy::Scope.new(current_user, Garden).resolve
      expect(@p.length).to eq(1)
      @p.each do |garden|
        expect(garden.is_private).to eql(false)
      end
    end

    it 'should only return public gardens in scope, unless they are users' do
      other_user = FactoryGirl.create :user
      Garden.create(user: other_user,
                    name: 'haha',
                    is_private: false)
      Garden.create(user: current_user,
                    name: 'nono',
                    is_private: true)
      @p = GardenPolicy::Scope.new(current_user, Garden).resolve
      expect(@p.length).to eq(2)
    end

    it 'should return all gardens in scope when user is admin' do
      Garden.create(user: current_user,
                    name: 'haha',
                    is_private: false)
      Garden.create(user: current_user,
                    name: 'nono',
                    is_private: true)
      @p = GardenPolicy::Scope.new(admin, Garden).resolve
      expect(@p.length).to eq(2)
    end
  end
end
