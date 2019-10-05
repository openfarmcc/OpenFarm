require 'spec_helper'

describe CropPolicy do
  subject { CropPolicy }

  let (:current_user) do
    FactoryBot.create :user
  end
  let (:crop) do
    FactoryBot.create :crop
  end
  let (:admin) do
    FactoryBot.create :user, admin: true
  end

  permissions :create? do
    it 'denies anonymous users to create a crop' do
      expect(CropPolicy).not_to permit(nil, crop)
    end
  end

  permissions :update? do
    it 'grants admin to update a crop' do
      expect(CropPolicy).to permit(admin, crop)
    end
    it 'grants users to update a crop' do
      expect(CropPolicy).to permit(current_user, crop)
    end
    it 'denies anonymous users to update a crop' do
      expect(CropPolicy).not_to permit(nil, crop)
    end
  end

  permissions :edit? do
    it 'grants users permission to view a crop edit page' do
      expect(CropPolicy).to permit(current_user, crop)
    end
    it 'denies anonymous users to view a crop edit page' do
      expect(CropPolicy).not_to permit(nil, crop)
    end
  end
end
