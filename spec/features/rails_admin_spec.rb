require 'spec_helper'

describe 'RailsAdmin' do
  include IntegrationHelper

  it 'denies ordinary users RailsAdmin' do
    user = FactoryBot.create(:user)
    login_as user
    visit '/admin'
    expect(page).to have_content('I told you kids to get out of here!')
    expect(current_path).to eq('/')
  end

  it 'denies unauthed users RailsAdmin' do
    visit '/admin'
    expect(page).to have_content('I told you kids to get out of here!')
    expect(current_path).to eq('/')
  end

  it 'allows admin access to RailsAdmin' do
    user = FactoryBot.create(:user, admin: true)
    login_as user
    visit '/admin'
    expect(current_path).to eq('/admin')
    expect(page).to have_content('Site Administration')
  end
end
