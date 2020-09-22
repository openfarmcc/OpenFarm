require 'spec_helper'

describe User do
  it 'Should create a valid user' do
    user = FactoryBot.create(:confirmed_user)
    expect(user).to be_valid
  end

  it 'Should not create a valid user if missing required info' do
    expect(FactoryBot.build(:confirmed_user, email: nil)).to_not be_valid
    expect(FactoryBot.build(:confirmed_user, display_name: nil)).to_not be_valid
  end

  it 'should return the favorite_crop image_path from user_setting' do
    user = FactoryBot.create(:confirmed_user, :with_user_setting)
    favorite_crop = FactoryBot.create(:crop, :radish)
    favorite_crop_path = favorite_crop.main_image_path
    user.user_setting.favorite_crops << favorite_crop
    expect(user.favorite_crop_image_from_user_setting).to eq(favorite_crop_path)
  end

  it 'should return nil is favorite_crop is not present' do
    user = FactoryBot.create(:confirmed_user, :with_user_setting)
    expect(user.user_setting.favorite_crops).to eq([])
    expect(user.favorite_crop_image_from_user_setting).to eq(nil)
  end

  it 'should be valid to have both location and units in user_setting' do
    user = FactoryBot.create(:user, :with_user_setting)
    expect(user.has_filled_required_settings?).to be true
  end

  context 'should be invalid to not fill in required settings' do
    it 'should be invalid to have either of location or units missing' do
      user = FactoryBot.create(:user)
      expect(user.has_filled_required_settings?).to be false
    end
  end
end
