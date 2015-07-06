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

  it 'should connect to mailchimp if mailing list and confirmed' do
    VCR.use_cassette('models/user_spec/mailing_list') do
      # These tests are pretty meaningless with the VCR, but we also don't
      # want to add fake sign-ups every time tests are run.
      user = FactoryGirl.create(:confirmed_user)
      user.mailing_list = true
      user.save
    end
  end

  it 'should connect to mailchimp if help list and confirmed' do
    VCR.use_cassette('models/user_spec/help_list') do
      # These tests are pretty meaningless with the VCR, but we also don't
      # want to add fake sign-ups every time tests are run.
      user = FactoryGirl.create(:confirmed_user)
      user.help_list = true
      user.save
    end
  end
end
