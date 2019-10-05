require 'spec_helper'

describe 'Crop pages', type: :controller do
  include IntegrationHelper
  let(:user) { FactoryBot.create(:user) }
  let(:crop) { FactoryBot.create(:crop, name: 'radish') }

  it 'shows and edits individual crops' do
    visit "/crops/#{crop._id}"
    expect(page).to have_content('radish')
  end

  # TODO: How do we test this?
  it 'uploads pictures'

  it 'shows create page for a crop' do
    login_as user
    visit '/crops/new'
    expect(page).to have_button('Save Crop')
  end

  it 'requires user log in to create a guide' do
    visit '/crops/new'
    expect(page).to have_content("You're not authorized to go to there.")
  end
end
