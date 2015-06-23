require 'spec_helper'

describe 'Guides' do
  include IntegrationHelper
  let (:guide) { FactoryGirl.create(:guide, name: 'Test Guide') }
  let (:crop) { FactoryGirl.create(:crop, name: 'radish') }
  let (:user) { FactoryGirl.create(:user) }

  it 'shows individual guides when logged in', js: true do
    login_as user
    visit guide_path(id: guide._id)
    expect(page).to have_content('Test Guide')
  end

  it 'shows individual guides when not logged in', js: true do
    visit guide_path(id: guide._id)
    expect(page).to have_content('Test Guide')
  end

  it 'shows the create guide page', js: true do
    FactoryGirl.create(:crop, name: 'radish')

    login_as user
    visit new_guide_path
    expect(page).to have_content('Lets Get Started!')
    # Capybarra doesn't search the value of disabled buttons???
    commit_button = page.find('input[name="commit"]')
    expect(commit_button['value']).to have_content('Choose a crop to continue')
    page.find('input#crop_name').click
    # wait_for_ajax
    fill_in :crop_name, with: 'radi'

    wait_for_ajax
    find_element('#crop_name + ul')
    # # TODO: The ajax that gets waited for doesn't necessarily return the
    # # right thing right away.
    # expect(page).to have_content('radish')
  end
end
