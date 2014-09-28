require "spec_helper"

describe 'User registrations' do
  include IntegrationHelper

  let(:user) { FactoryGirl.create(:user) }
  # TODO JS: false
  it 'can change user settings' do
    login_as user
    visit edit_user_registration_path(user)
    fill_in :user_display_name, with: 'Bert'
    fill_in :user_current_password, with: user.password
    click_button 'Update User'
    see('You updated your account successfully')
    expect(user.reload.display_name).to eq('Bert')
  end

  it 'registers for an account' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_password_confirmation, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    fill_in :user_location, with: 'Clevland'
    fill_in :user_soil_type, with: 'rocky'
    fill_in :user_years_experience, with: 3
    fill_in :user_preferred_growing_style, with: 'aquaponics'
    click_button 'Create User'
    see "Welcome! You have signed up successfully."
    usr = User.find_by(email: 'm@il.com')
    expect(usr.display_name).to eq('Rick')
    expect(usr.valid_password?('password123')).to eq(true)
    expect(usr.email).to eq('m@il.com')
    expect(usr.location).to eq('Clevland')
    expect(usr.soil_type).to eq('rocky')
    expect(usr.years_experience).to eq(3)
    expect(usr.preferred_growing_style).to eq('aquaponics')
  end
end
