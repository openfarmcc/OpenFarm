require 'spec_helper'

describe 'User sessions' do
  include IntegrationHelper

  let(:user) { FactoryGirl.create(:user) }

  it 'registers for an account should not be confirmed' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree
    click_button 'Join OpenFarm'
    usr = User.find_by(email: 'm@il.com')
    expect(usr.display_name).to eq('Rick')
    expect(usr.valid_password?('password123')).to eq(true)
    expect(usr.agree).to eq(true)
    expect(usr.email).to eq('m@il.com')
    expect(usr.confirmed?).to eq(false)
  end

  it 'fails to register when user does not subscribe to tos' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Join OpenFarm'
    see 'Agree to the Terms of Service and Privacy Policy'
  end

  it 'logs out' do
    login_as user
    visit root_path
    page.first(:link, 'Log out').click
    see('Signed out successfully.')
  end

  it 'does not let the user access the admin panel' do
    visit rails_admin.dashboard_path
    expect(page).to have_content('I told you kids to get out of here!')
  end

  # it 'should redirect the user to their finish page after sign up' do
  #   visit new_user_registration_path
  #   fill_in :user_display_name, with: 'Rick'
  #   fill_in :user_password, with: 'password123'
  #   fill_in :user_email, with: 'm@il.com'
  #   check :user_agree
  #   click_button 'Create account'
  #   expect(page).to have_content("Welcome Rick")
  # end

  # it 'should redirect the user to the page they were viewing after sign up' do
  #   visit "/guides/new"
  #   see ("You need to sign in or sign up before continuing.")
  #   click_link "Sign up"
  #   fill_in :user_display_name, with: 'Rick'
  #   fill_in :user_password, with: 'password123'
  #   fill_in :user_email, with: 'm@il.com'
  #   check :user_agree
  #   click_button 'Create account'
  #   expect(page).to have_content(I18n::t('guides.new.new_guide_steps.create_a_growing_guide'))
  # end

  it 'should create a new garden for a newly registered user' do
    usr = sign_up_procedure

    expect(Garden.all.last.user).to eq (usr)
  end

  it 'user gets redirected to their finish page after sign up confirmation' do
    usr = sign_up_procedure

    expect(page).to have_content('Your account was successfully confirmed')

    see 'Welcome Rick'
    # TODO: this isn't working
    # wait_until_angular_ready
    # fill_in :units, with: 'Chicago'
    click_button 'Next: Add Garden'

    expect(page).to have_content('Your Gardens')
  end

  it 'should link to mailchimp if user chooses to be on mailing list' do
    usr = sign_up_procedure

    choose('yes-email')

    click_button 'Next: Add Garden'
  end

  it 'should link to mailchimp if user chooses to be on mailing list' do
    usr = sign_up_procedure

    choose('yes-help')

    click_button 'Next: Add Garden'
  end

  it 'should show an error message if no location is defined'

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

  it 'should tell the user that fields are missing'

  it 'should redirect if there was a problem with the token' do
    visit '/users/confirmation?confirmation_token=fake_token'
    expect(page).to have_content('Resend confirmation instructions')
  end

  def extract_url_from_email(email)
    doc = Nokogiri::HTML(email.to_s)
    hrefs = doc.xpath("//a[starts-with(text(), 'C')]/@href").map(&:to_s)
    hrefs[0]
  end

  def sign_up_procedure
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    check :user_agree

    click_button 'Join OpenFarm'
    usr = User.find_by(email: 'm@il.com')

    # This is a bit of a hack, but I can't think of a different
    # way to get the token that is sent via email (it's different from
    # what gets stored in the DB)
    href = extract_url_from_email(usr.resend_confirmation_instructions.body)

    visit href
    usr
  end
end
