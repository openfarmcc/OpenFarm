require "spec_helper"

describe 'Crop searches' do
  let!(:crop){FactoryGirl.create(:crop)}

  it 'finds documents' do
    visit root_path
    fill_in 'q', with: 'radish'
    click_button 'Search!'
    expect(page).to have_content('Horseradish (Armoracia rusticana, syn. Cochlearia armoracia)')
  end

  it 'handles empty searches'

  it 'handles pagination'

  it 'paginates results'

end
