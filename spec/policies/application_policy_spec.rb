# frozen_string_literal: true

require 'spec_helper'

describe ApplicationPolicy do
  subject { ApplicationPolicy }

  let (:current_user) do
    FactoryBot.create :user
  end
  let (:other_user) do
    FactoryBot.create :user
  end
  let (:private_user) do
    FactoryBot.create :user, is_private: true
  end
  let (:admin) do
    FactoryBot.create :user, admin: true
  end

  permissions :index? do
    it 'should default to deny viewing the index for a record' do
      expect(ApplicationPolicy).not_to permit(current_user, private_user)
    end
  end

  permissions :show? do
    it 'should default to deny showing a record' do
      expect(ApplicationPolicy).not_to permit(current_user, private_user)
    end
  end

  permissions :update? do
    it 'should default to denying an update' do
      expect(ApplicationPolicy).not_to permit(current_user, private_user)
    end
  end

  # This is just a hack - the scope on the application policy
  # is just a wrapper method that returns the scope being
  # called for.
  context 'for a user' do
    it 'should only return records action' do
      @p = ApplicationPolicy::Scope.new(current_user, User).resolve
    end
  end
end
