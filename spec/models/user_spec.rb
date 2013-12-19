require 'spec_helper'

describe User do
  it 'Should create a valid user' do
    expect(FactoryGirl.create(:user)).to be_valid
  end
  
  it 'Should not create a valid user if missing required info' do
    expect(FactoryGirl.build(:user, email_address: nil)).to_not be_valid
    expect(FactoryGirl.build(:user, display_name: nil)).to_not be_valid
  end
  
  it 'Should not create a valid user if password is missing' do
    expect(FactoryGirl.build(:user, password: nil)).to_not be_valid
  end
end