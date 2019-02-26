require 'spec_helper'

describe 'Crop search', type: :controller do
  def asset_url(relative_path)
    "#{host_with_port}#{Rails.application.config.assets.prefix}/"+
    "#{relative_path}"
  end

  def host_with_port
    "#{current_host}:#{Capybara.current_session.server.port}"
  end

  let!(:crop) { FactoryBot.create(:crop, :radish) }

  it 'finds individual crops' # , js: true do
  #   visit root_path
  #   FactoryBot.create_list(:crop, 10)
  #   FactoryBot.create(:crop, name: 'radish')
  #   Crop.searchkick_index.refresh
  #   fill_in 'q', with: 'radish'
  #   click_button 'Search'
  #   expect(page).to have_content('radish')
  #   expect(page)
  #     .to_not have_content("Sorry, we don't have any crops matching")
  # end

  it 'handles empty searches', js: true do
    Crop.collection.drop
    visit root_path
    fill_in 'q', with: ''
    FactoryBot.create_list(:crop, 10)
    Crop.searchkick_index.refresh
    click_button 'Search'
    expect(page).to have_content(Crop.last.name)
    # Don't use crops with apostraphes in the name- creates weird errors.
    crop        = Crop.all.to_a.detect { |x| !x.name.include?("'") }
    title       = crop.name
    description = crop.description
    image       = crop.main_image_path
    selector1   = "meta[property='og:title'][content='#{title}']"
    expect(page).to have_css(selector1, visible: false)
    selector2   = "meta[property='og:description'][content='#{description}']"
    expect(page).to have_css(selector2, visible: false)
    selector3   = "meta[property='og:image']"+
                  "[content='#{host_with_port}#{image}']"
    expect(page).to have_css(selector3, visible: false)
  end

  it 'handles empty search results', js: true do
    Crop.collection.drop
    FactoryBot.create_list(:crop, 10)
    Crop.searchkick_index.refresh
    visit root_path
    fill_in 'q', with: 'pokemon'
    click_button 'Search'
    expect(page).to have_content("Sorry, we don't have any crops matching")
    description = I18n.t('application.site_description')
    title = I18n.t('crop_searches.show.title')
    selector1 = "meta[property='og:description'][content='#{description}']"
    expect(page).to have_css(selector1, visible: false)
    selector2 = "meta[property='og:title'][content='#{title}']"
    expect(page).to have_css(selector2, visible: false)
    image = 'openfarm-learn-to-grow-anything-with-community-created-guides'
    meta_image = find("meta[property='og:image']", visible: false)
    expect(meta_image).to be
    expect(meta_image[:content]).to include(image)
  end

  it 'handles plurals', js: true do
    Crop.collection.drop
    FactoryBot.create_list(:crop, 10)
    q = FactoryBot.create(:crop, :radish).name
    Crop.searchkick_index.refresh
    visit root_path
    fill_in 'q', with: q
    click_button 'Search'
    expect(page).to have_content(crop.name)
    expect(page).to_not have_content("Sorry, we don't have any crops matching")
  end

  it 'handles misspellings' # , js: true do
  #   visit root_path
  #   FactoryBot.create_list(:crop, 10)
  #   FactoryBot.create(:crop, name: 'radish')
  #   Crop.searchkick_index.refresh
  #   fill_in 'q', with: 'radis'
  #   click_button 'Search'
  #   expect(page).to have_content('radish')
  #   expect(page)
  #     .to_not have_content("Sorry, we don't have any crops matching")
  # end

  it 'handles multiple words' # , js: true do
  #   visit root_path
  #   FactoryBot.create_list(:crop, 10)
  #   FactoryBot.create(:crop, name: 'radish')
  #   Crop.searchkick_index.refresh
  #   fill_in 'q', with: 'pear radish'
  #   click_button 'Search'
  #   expect(page).to have_content('radish')
  #   expect(page)
  #     .to_not have_content("Sorry, we don't have any crops matching")
  # end

  it 'has a top nav bar' # , js: true do
  #   skip 'this test does not pass on CI - RickCarlino'
  #   visit crop_search_via_get_path(cropsearch: { q: 'red' })
  #   fill_in 'q', with: crop.name
  #   FactoryBot.create_list(:crop, 10)
  #   Crop.searchkick_index.refresh
  #   click_button 'Search'
  #   expect(page).to have_content(crop.name)
  # end
end
