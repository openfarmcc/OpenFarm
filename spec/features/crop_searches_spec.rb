require 'spec_helper'

describe 'Crop search', type: :controller do
  def asset_url(relative_path)
    "#{host_with_port}#{Rails.application.config.assets.prefix}/#{relative_path}"
  end

  def host_with_port
    "#{current_host}:#{Capybara.current_session.server.port}"
  end
  
  it 'handles empty searches', js: true do
    visit root_path
    fill_in 'q', with: ''
    FactoryGirl.create_list(:crop, 10)
    Crop.searchkick_index.refresh
    click_button 'Search'
    title = Crop.first.name
    #first test - look for title
    expect(page).to have_content(title)
    #first test - look for description

    description = Crop.first.description
    expect(page).to have_content(title)

    image = Crop.first.main_image_path #image fix to come after configuration is set up

  end

end
