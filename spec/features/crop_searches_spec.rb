require "spec_helper"

describe 'Crop search', :type => :controller do
  let!(:crop){FactoryGirl.create(:crop)}

  it 'finds documents' do
    visit root_path
    fill_in 'q', with: 'radish'
    click_button 'Search!'
    expect(page).to have_content('Horseradish (Armoracia rusticana, syn. Cochlearia armoracia)')
  end

  it 'handles empty searches' do
    visit root_path
    fill_in 'q', with: ''
    click_button 'Search!'
    expect(page).to have_content('Horseradish (Armoracia rusticana, syn. Cochlearia armoracia)')
  end
end
