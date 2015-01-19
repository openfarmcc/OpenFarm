require 'spec_helper'

describe 'Crop pages', type: :controller do
  include IntegrationHelper
  let(:user) { FactoryGirl.create(:user) }
  let(:crop) { FactoryGirl.create(:crop, name: 'radish') }

  it 'shows and edits individual crops' do
    visit "/crops/#{crop._id}"
    expect(page).to have_content('radish')
  end

  # TODO: How do we test this?
  it 'uploads pictures'

  it 'fills in the edit page for a crop' do
    visit "/crops/#{crop._id}/edit"
    expect(page).to have_content('radish')
    fill_in :crop_common_names, with: 'Radish, Red Thing\n, New'
    click_button 'Save Crop'
    expect(page).to have_content('Radish,Red Thing,New')
    expect(crop.reload.common_names.length).to eq(3)
  end

  it 'shows create page for a crop' do
    login_as user
    visit '/crops/new'
    expect(page).to have_button('Save Crop')
  end

  it 'requires user log in to create a guide' do
    visit '/crops/new'
    expect(page).to have_content('Woops, that\'s not a page!')
  end
end
