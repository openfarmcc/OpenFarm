require 'spec_helper'

describe UserPolicy do
  subject { UserPolicy }

  let (:current_user) { FactoryGirl.create :user }
  let (:other_user) { FactoryGirl.create :user }
  let (:private_user) { FactoryGirl.create :user, is_private: true}
  let (:admin) { FactoryGirl.create :user, admin: true }

  permissions :show? do
    it 'denies access if viewed user is private' do
      expect(UserPolicy).not_to permit(current_user, private_user)
    end

    it 'grants access if viewed user is private and current_user is admin' do
      expect(UserPolicy).to permit(admin, private_user)
    end

    it 'grants access if viewed user is the current user' do
      expect(UserPolicy).to permit(private_user, private_user)
    end
  end

  permissions :update? do
    it 'denies updating if viewed user is not current user' do
      expect(UserPolicy).not_to permit(current_user, other_user)
    end
    it 'grants update if user is current user' do
      expect(UserPolicy).to permit(current_user, current_user)
    end
    it 'grants update if user is admin user' do
      expect(UserPolicy).to permit(admin, other_user)
    end
  end
end
