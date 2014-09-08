require "spec_helper"

describe "Guides" do
  include IntegrationHelper
  # js: true runs the test in a headless webkit browser.
  it "creates a guide", js: true do
    # TODO, test when it's done.
    # FactoryGirl.create(:crop, name: 'The whole plant name')
    # visit new_guide_path
    # fill_in :crop_name, with: 'whole'
    # wait_for_ajax # Gives the server time to respond.
    # # Test that the typeahead search is working...
    # expect(page).to have_content('The whole plant name')
  end
end
