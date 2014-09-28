require 'spec_helper'

describe 'User sessions' do
  include IntegrationHelper
  let(:user) { FactoryGirl.create(:user) }

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

  it 'logs out' do
    login_as user
    visit root_path
    click_link 'Log out'
    see('Signed out successfully.')
  end

  it 'does not let the user access the admin panel' do
    visit rails_admin.dashboard_path
    expect(page).to have_content('I told you kids to get out of here!')
  end
end
