require 'spec_helper'

describe 'User registrations' do
  include IntegrationHelper

  let(:user) { FactoryGirl.create(:user) }

  it 'can change user settings' do
    login_as user
    visit edit_user_registration_path(user)
    fill_in :user_display_name, with: 'Bert'
    fill_in :user_current_password, with: user.password
    click_button 'Update User'
    see('You updated your account successfully')
    expect(user.reload.display_name).to eq('Bert')
  end

  it 'opts in to the mailing list' do
    pending 'This is broke. Why?'
    visit new_user_registration_path
    fill_in :user_email, with: 'bert@me.com'
    fill_in :user_display_name, with: 'Bert'
    fill_in :user_password, with: 'hello_world'
    fill_in :user_password_confirmation, with: 'hello_world'
    check('user_mailing_list')
    see 'Get (occassional) updates about OpenFarm via email'
    click_button 'Create User'
    see('You have signed up successfully.')
    expect(user.reload.mailing_list).to eq(true)
  end

  it 'opts out of the mailing list' do
    visit new_user_registration_path
    fill_in :user_email, with: 'bert@me.com'
    fill_in :user_display_name, with: 'Bert'
    fill_in :user_password, with: 'hello_world'
    fill_in :user_password_confirmation, with: 'hello_world'
    uncheck :user_mailing_list
    see 'Get (occassional) updates about OpenFarm via email'
    click_button 'Create User'
    see('You have signed up successfully.')
    expect(user.reload.mailing_list).to eq(false)
  end
end
