# frozen_string_literal: true

require 'spec_helper'

describe 'Crop search', :js do
  def asset_url(relative_path)
    "#{host_with_port}#{Rails.application.config.assets.prefix}/" \
      "#{relative_path}"
  end

  def host_with_port
    "#{current_host}:#{Capybara.current_session.server.port}"
  end

  let!(:crop) { FactoryBot.create(:crop, :radish) }

  it 'finds individual crops' do
    FactoryBot.create_list(:crop, 10)
    FactoryBot.create :crop, name: 'banana'
    Crop.searchkick_index.refresh

    visit root_path
    fill_in 'q', with: 'banana'
    click_button 'Search'
    expect(page).to have_content('banana')
    expect(page).to_not have_text("Sorry, we don't have any crops matching")
  end

  it 'handles empty searches' do
    Crop.collection.drop
    FactoryBot.create_list(:crop, 10)
    Crop.reindex

    visit root_path
    fill_in 'q', with: ''
    click_button 'Search'
    expect(page).to have_content(Crop.last.name)
    # Don't use crops with apostraphes in the name- creates weird errors.
    crop = Crop.all.to_a.detect { |x| !x.name.include?("'") }
    title = crop.name
    description = crop.description
    image = crop.main_image_path
    selector1 = "meta[property='og:title'][content='#{title}']"
    expect(page).to have_css(selector1, visible: false)
    selector2 = "meta[property='og:description'][content='#{description}']"
    expect(page).to have_css(selector2, visible: false)
    selector3 = "meta[property='og:image']" \
                "[content='#{host_with_port}#{image}']"
    expect(page).to have_css(selector3, visible: false)
  end

  it 'handles empty search results' do
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

  describe 'fuzzy matches' do
    shared_examples 'perform search' do
      before do
        FactoryBot.create_list(:crop, 10)
        FactoryBot.create(:crop, name: 'radish')
        Crop.searchkick_index.refresh
      end
      it 'finds the radish' do
        visit root_path
        fill_in 'q', with: query
        click_button 'Search'
        expect(page).to have_content('radish')
        expect(page).to_not have_content("Sorry, we don't have any crops matching")
      end
    end

    describe 'with plurals' do
      let(:query) { 'radishes ' }
      include_examples 'perform search'
    end

    describe 'with misspellings' do
      let(:query) { 'radis' }
      include_examples 'perform search'
    end

    describe 'with multiple words' do
      let(:query) { 'pear radish' }
      include_examples 'perform search'
    end

    describe 'with mis-matched case' do
      let(:query) { 'RADISH' }
      include_examples 'perform search'
    end
  end

  it 'has a top nav bar' do
    FactoryBot.create_list(:crop, 10)
    Crop.searchkick_index.refresh

    visit crop_search_via_get_path(cropsearch: { q: 'red' })
    fill_in 'q', with: crop.name
    click_button 'Search'
    expect(page).to have_content(crop.name)
  end
end
