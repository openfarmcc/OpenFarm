require "spec_helper"

describe "User sessions" do
  include IntegrationHelper
  let(:user) { FactoryGirl.create(:user) }
  it "logs in" do
    visit root_path
    click_link "Create an Account"
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'passwerd'
    fill_in :user_password_confirmation, with: 'passwerd'
    fill_in :user_email, with: 't@g.com'
    fill_in :user_email, with: 't@g.com'
    fill_in :user_location, with: 'Portland'
    fill_in :user_soil_type, with: 'rocky'
    fill_in :user_years_experience, with: '3'
    fill_in :user_preferred_growing_style, with: 'manure composting'
    click_button "Create User"
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  it "logs out" do
    login_as user
    visit root_path
    click_link "Logout"
    see('Signed out successfully.')
  end

  it "doesn't let the user access the admin panel" do
    visit rails_admin.dashboard_path
    expect(page).to have_content('I told you kids to get out of here!')
  end

  it "lets the user access the admin panel if they're an admin"

end
