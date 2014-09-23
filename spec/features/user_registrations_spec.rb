require "spec_helper"

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
    expect(user.display_name).to eq('bert')
  end
end
