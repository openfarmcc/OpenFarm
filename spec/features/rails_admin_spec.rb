require 'spec_helper'

describe 'RailsAdmin' do
  include IntegrationHelper

  it 'allows admin access to RailsAdmin' do
    skip "We will add rails_admin back later, after the big upgrade"
    # user = FactoryGirl.create(:user, admin: true)
    # login_as user
    # visit '/admin'
    # expect(current_path).to eq('/admin')
    # expect(page).to have_content('Site Administration')
  end
end
