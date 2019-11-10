require 'spec_helper'

describe 'Crop pages', :js do
  let(:user) { FactoryBot.create(:user) }
  let(:crop) { FactoryBot.create(:crop, name: 'radish') }

  it 'shows and edits individual crops' do
    visit "/crops/#{crop._id}"
    expect(page).to have_content('radish')
  end

  it 'edits crops' do
    login_as user
    visit "/crops/#{crop._id}"
    expect(page).to have_link('Edit crop')
    click_link 'Edit crop'
    expect(page).to have_content('Edit radish')

    fill_in id: 'crop_binomial_name', with: 'Raphanus sativus'
    fill_in id: 'crop_description', with: 'easter eggs'

    click_button 'Save Crop'
    expect(page).to have_text 'Raphanus sativus'
    expect(page).to have_text 'easter eggs'
  end

  # TODO: How do we test this?
  pending 'uploads pictures'

  it 'shows create page for a crop' do
    login_as user
    visit '/crops/new'
    expect(page).to have_button('Save Crop')
  end

  it 'requires user log in to create a guide' do
    visit '/crops/new'
    expect(page).to have_content('You\'re not authorized to go to there.')
  end
end
