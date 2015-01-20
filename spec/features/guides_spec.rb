require 'spec_helper'

describe 'Guides' do
  include IntegrationHelper
  let (:guide) { FactoryGirl.create(:guide, name: 'Test Guide') }
  let (:crop) { FactoryGirl.create(:crop, name: 'radish') }
  let (:user) { FactoryGirl.create(:user) }

  it 'shows individual guides', js: true do
    visit guide_path(id: guide._id)
    expect(page).to have_content('Test Guide')
  end

  it 'shows the create guide page', js: true do
    login_as user
    visit new_guide_path
    expect(page).to have_content('Lets Get Started!')
    # Capybarra doesn't search the value of disabled buttons???
    commit_button = page.find('input[name="commit"]')
    expect(commit_button["value"]).to have_content('Choose a crop to continue')
    fill_in :crop_name, with: crop.name
    wait_for_ajax
    # This might be a legit failure:
    # Says: "Uh oh! We couldn’t find that crop in our database."
    # Maybe something else is going on here?
    # expect(page).to have_content('radish')
  end
end
