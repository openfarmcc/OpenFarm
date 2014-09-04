require "spec_helper"

describe 'Crop search', :type => :controller do
  let!(:crop) { FactoryGirl.create(:crop, :radish) }

  it 'finds documents' do
    visit root_path
    fill_in 'q', with: 'radish'
    click_button 'Search!'
    expect(page).to have_content(crop.name)
  end

  it 'handles empty searches' do
    visit root_path
    fill_in 'q', with: ''
    click_button 'Search!'
    expect(page).to have_content(crop.name)
  end

  it 'handles plurals' do
    visit root_path
    fill_in 'q', with: 'radishes'
    click_button 'Search!'
    expect(page).to have_content(crop.name)
  end
end
