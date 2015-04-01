require 'spec_helper'

describe 'User registrations' do
  include IntegrationHelper

  let(:user) { FactoryGirl.create(:user) }

  it 'can change user settings' do
    login_as user
    visit edit_user_registration_path(user)
    fill_in :user_display_name, with: 'Bert'
    fill_in :user_current_password, with: user.password
    click_button 'Update account'
    see('You updated your account successfully')
    expect(user.reload.display_name).to eq('Bert')
  end

  it 'can change user password' do
    login_as user
    visit edit_user_registration_path(user)
    fill_in :user_current_password, with: user.password
    fill_in :user_password, with: "bert1234"
    click_button 'Update account'
    see('You updated your account successfully')
  end

  it 'should fail with wrong password' do
    login_as user
    original_name = user.display_name
    visit edit_user_registration_path(user)
    fill_in :user_current_password, with: 'wrongpassword'
    fill_in :user_display_name, with: 'Bert'
    click_button 'Update account'
    new_name = user.reload.display_name
    # Dunno why, but it wasn't liking user.reload.display_name
    # in the expect() below
    expect(new_name).to eq(original_name)
    see('Current password is invalid')
  end

  it 'should fail with faulty new password' do
    login_as user
    visit edit_user_registration_path(user)
    fill_in :user_current_password, with: user.password
    fill_in :user_password, with: "2short"
    click_button 'Update account'
    see('Password is too short')
  end

  it 'should fail without using a password to delete an account' do
    login_as user
    visit edit_user_registration_path(user)
    click_button 'Permanently delete account'
    see('You need to supply your password to delete your account')
  end

  it 'should succeed when using a password to delete an account' do
    login_as user
    visit edit_user_registration_path(user)
    fill_in :user_password_confirmation, with: user.password
    click_button 'Permanently delete account'
    see('Your account was successfully cancelled.')
    expect { User.find(user.id) }.to raise_error(
      Mongoid::Errors::DocumentNotFound)
  end
end
