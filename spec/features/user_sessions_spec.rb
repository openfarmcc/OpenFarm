require 'spec_helper'

describe 'User sessions' do
  include IntegrationHelper
  let(:user) { FactoryGirl.create(:user) }

  it 'registers for an account' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Create account'
    see 'Welcome! You have signed up successfully.'
    usr = User.find_by(email: 'm@il.com')
    expect(usr.display_name).to eq('Rick')
    expect(usr.valid_password?('password123')).to eq(true)
    expect(usr.agree).to eq(true)
    expect(usr.email).to eq('m@il.com')
  end

  it 'fails to register when user does not subscribe to tos' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Create account'
    see 'Agree to the Terms of Service and Privacy Policy'
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

  it 'should redirect the user to their finish page after sign up' do
    visit new_user_registration_path
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Create account'
    expect(page).to have_content("Welcome Rick")
  end

  it 'should redirect the user to the page they were viewing after sign up' do
    visit "/guides/new"
    see ("You need to sign in or sign up before continuing.")
    click_link "Sign up"
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Create account'
    expect(page).to have_content(I18n::t('guides.new.new_guide_steps.create_a_growing_guide'))
  end

  it 'should create a new garden for a newly registered user' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Create account'
    usr = User.find_by(email: 'm@il.com')
    expect(Garden.all.last.user).to eq (usr)
  end

  it 'should show an error message if no location is defined', js: true do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Create account'
    click_button 'Next: Add Garden'
    expect(page).to have_content("Location can't be blank")
  end

  it 'should direct to the gardens page after successful completion', js: true do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Create account'
    fill_in :location, with: 'Chicago'
    click_button 'Next: Add Garden'
    expect(page).to have_content('Your Gardens')
  end

  it 'should redirect to sign up page when user is not authorized' do
    visit new_crop_path
    see('You\'re not authorized to go to there.')
    user.password = 'password123'
    user.password_confirmation = 'password123'
    user.save
    fill_in :user_email, with: user[:email]
    fill_in :user_password, with: 'password123'
    click_button 'Sign in'
    expect(page).to have_content('Add a new crop!')
  end

  it 'should direct to root after log in' do
    visit root_path
    click_link 'Log in'
    user.password = 'password123'
    user.password_confirmation = 'password123'
    user.save
    fill_in :user_email, with: user[:email]
    fill_in :user_password, with: 'password123'
    click_button 'Sign in'
    expect(page).to have_content("Hi, #{user.display_name}")
  end
end
