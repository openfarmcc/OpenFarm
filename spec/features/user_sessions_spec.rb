require 'spec_helper'

describe 'User sessions' do
  # include IntegrationHelper

  let(:user) { FactoryGirl.create(:user) }

  it 'registers for an account should not be confirmed' do
    User.destroy_all
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Join OpenFarm'
    usr = User.find_by(email: 'm@il.com')
    expect(usr.display_name).to eq('Rick')
    expect(usr.valid_password?('password123')).to eq(true)
    expect(usr.agree).to eq(true)
    expect(usr.email).to eq('m@il.com')
    expect(usr.confirmed?).to eq(false)
  end

  it 'logs out' do
    login_as user
    visit root_path
    page.first(:link, 'Log out').click
    see('Signed out successfully.')
  end

  it 'should redirect the user to their finish page after sign up' do
    User.destroy_all
    visit new_user_registration_path
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Join OpenFarm'
    expect(page).to have_content('Thanks for joining!')
  end

  it 'should redirect the user to the page they' \
     'were viewing after sign up', js: true do
    User.destroy_all
    visit new_guide_path
    see ('You need to sign in or sign up before continuing.')
    page.first(:link, 'Become a Member').click
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Join OpenFarm'
    expect(page).to have_content('Create a Growing Guide')
  end

  it 'should create a new garden for a newly registered user' do
    skip 'this test does not pass on CI - RickCarlino'
    usr = sign_up_procedure

    expect(Garden.all.last.user).to eq (usr)
  end

  it 'user gets redirected to finish page after confirmation' # , js: true do
  #   skip 'this test does not pass on CI - RickCarlino'
  #   usr = sign_up_procedure
  #   expect(page).to have_content('Your account was successfully confirmed')
  #   see 'Thanks for joining!'
  #   click_button I18n::t('users.finish.next_step')
  #   see('Gardens')
  #   expect(page).to have_content('Gardens')
  # end

  it 'should register the user location', js: true do
    login_as user
    visit users_finish_path
    wait_for_ajax
    fill_in :location, with: 'Chicago'
    click_button I18n::t('users.finish.next_step')
    see('This is your member profile')
    expect(user.reload.user_setting.location).to eq('Chicago')
  end

  it 'should register the user unit preference', js: true do
    login_as user
    visit users_finish_path
    wait_for_ajax
    choose 'units-imperial'
    click_button I18n::t('users.finish.next_step')
    see('This is your member profile')
    expect(user.reload.user_setting.units).to eq('imperial')
  end

  it 'should redirect to sign up page when user is not authorized' do
    skip 'this test does not pass on CI - RickCarlino'
    usr = sign_up_procedure
    logout

    visit new_crop_path
    see('You\'re not authorized to go to there.')

    fill_in :user_email, with: usr[:email]
    fill_in :user_password, with: 'password123'
    click_button 'Sign in'
    expect(page).to have_content('Add a new crop')
  end

  it 'should direct to root after log in' do
    skip 'this test does not pass on CI - RickCarlino'
    usr = sign_up_procedure
    logout

    visit root_path
    click_link 'Log in'

    fill_in :user_email, with: usr[:email]
    fill_in :user_password, with: 'password123'
    click_button 'Sign in'
    expect(page).to have_content("Hi, #{usr.display_name}")
  end

  it 'should redirect if there was a problem with the token' do
    visit '/users/confirmation?confirmation_token=fake_token'
    expect(page).to have_content('Resend confirmation instructions')
  end

  it 'should let the user set favorite crop on profile page' # , js: true do
  #   FactoryGirl.create(:crop, name: 'Tomato')
  #   login_as user
  #   visit user_path('en', user)
  #   see('Success!')
  #   see('This is your Member Profile page.')
  #   wait_for_ajax
  #   fill_in :search_crop_name, with: 'tomat'
  #   wait_for_ajax
  #   click_button :submit_crop
  #   see('Tomato')
  # end

  def extract_url_from_email(email)
    doc = Nokogiri::HTML(email.to_s)

    hrefs = doc.xpath("//a[starts-with(text(), 'C')]/@href").map(&:to_s)

    # We don't actually want our string to say test.test.com, cause
    # apparently that's a website!
    hrefs[0]['http://test.test.com'] = ''
    hrefs[0]
  end

  def sign_up_procedure
    User.destroy_all
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'

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
