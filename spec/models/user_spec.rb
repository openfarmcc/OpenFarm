require 'spec_helper'

describe User do
  it 'Should create a valid user' do
    user = FactoryGirl.create(:confirmed_user)
    expect(user).to be_valid
  end

  it 'Should not create a valid user if missing required info' do
    expect(FactoryGirl.build(:confirmed_user, email: nil)).to_not be_valid
    expect(FactoryGirl.build(:confirmed_user, display_name: nil)).to_not be_valid
  end
end
