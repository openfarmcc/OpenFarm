require 'spec_helper'

describe 'Crop search', type: :controller do
  let!(:crop) { FactoryGirl.create(:crop, :radish) }

  it 'finds documents' do
    visit root_path
    FactoryGirl.create_list(:crop, 10)
    fill_in 'q', with: 'radish'
    click_button 'Search!'
    expect(page).to have_content(crop.name)
  end

  it 'handles empty searches' do
    visit root_path
    fill_in 'q', with: ''
    FactoryGirl.create_list(:crop, 10)
    click_button 'Search!'
    expect(page).to have_content(Crop.last.name)
  end

  it 'handles plurals' do
    visit root_path
    fill_in 'q', with: crop.name
    FactoryGirl.create_list(:crop, 10)
    click_button 'Search!'
    expect(page).to have_content(crop.name)
  end

  it 'has a top nav bar' do
    visit crop_search_via_get_path(cropsearch: {q: 'red'})
    fill_in 'q', with: crop.name
    FactoryGirl.create_list(:crop, 10)
    click_button 'Search!'
    expect(page).to have_content(crop.name)
  end
end
