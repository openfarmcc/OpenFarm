require 'spec_helper'

describe 'Guides' do
  include IntegrationHelper
  let (:guide) { FactoryGirl.create(:guide, name: 'Test Guide') }
  let (:crop) { FactoryGirl.create(:crop, name: 'radish') }
  let (:user) { FactoryGirl.create(:user) }

  it 'shows individual guides', js: true do
    visit "guides/#{guide._id}"
    expect(page).to have_content('Test Guide')
  end

  it 'shows the create guide page', js: true do
    login_as user
    visit 'guides/new'

    sleep 5
    puts "html: #{page.html}"
    expect(page).to have_content('Lets Get Started')
    expect(page).to have_button('Choose a crop to continue')
    fill_in :crop_name, with: crop.name
    expect(page).to have_link('radish')
  end
end
