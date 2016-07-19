require 'spec_helper'

describe 'User features', type: :feature do
  def host_with_port
    host_with_port = current_host
    if Capybara.current_session.server
      host_with_port += ":#{Capybara.current_session.server.port}"
    end
    host_with_port
  end

  def asset_url(relative_path)
    "#{host_with_port}#{Rails.application.config.assets.prefix}/
      #{relative_path}"
  end

  it 'should return the user profile name when sharing user profile' do
    user = FactoryGirl.create(:confirmed_user, :with_user_setting)
    login_as user
    visit user_path(:en, user.id)
    title = user.display_name + ' Profile'
    expect(page).to have_css "meta[property='og:title']
      [content='#{title}']", visible: false
  end

  context 'should return appropriate image when sharing user profile' do
    context 'when favorite_crop is present' do
      let(:user) { FactoryGirl.create(:user, :with_user_setting) }
      it 'returns favorite_crop image' do
        favorite_crop = FactoryGirl.create(:crop, :radish)
        favorite_crop_path = favorite_crop.main_image_path
        user.user_setting.favorite_crops << favorite_crop
        login_as user
        visit user_path(:en, user.id)
        expect(page).to have_css "meta[property='og:image']
          [content='#{host_with_port}#{favorite_crop_path}']", visible: false
      end
    end

    context 'when favorite_crop is not present' do
      let(:user) { FactoryGirl.create(:user, :with_user_setting) }
      it 'returns OpenFarm image' do
        image = 'openfarm-learn-to-grow-anything
                 -with-community-created-guides.jpg'
        login_as user
        visit user_path(:en, user.id)
        expect(page).to have_css "meta[property='og:image']
          [content='#{asset_url(image)}']", visible: false
      end
    end
  end
end
