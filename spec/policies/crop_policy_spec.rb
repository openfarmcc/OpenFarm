require 'spec_helper'

describe CropPolicy do
  subject { CropPolicy }

  let (:current_user) { FactoryGirl.create :user }
  let (:crop) { FactoryGirl.create :crop }
  let (:admin) { FactoryGirl.create :user, admin: true }

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
end
