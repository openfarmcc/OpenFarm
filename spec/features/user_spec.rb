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
    "#{host_with_port}#{Rails.application.config.assets.prefix}/#{relative_path}"
  end

  it 'should return the user profile name when sharing user profile' do
    user = FactoryBot.create(:confirmed_user, :with_user_setting)
    login_as user
    visit user_path(:en, user.id)
    selector = "meta[property='og:title']" \
               "[content=\"#{user.display_name} Profile\"]"
    expect(page).to have_css(selector, visible: false)
  end

  context 'should handle returning appropriate image when sharing user profile' do
    context 'when favorite_crop is present' do
      let(:user) { FactoryBot.create(:user, :with_user_setting) }
      it 'returns favorite_crop image' do
        favorite_crop = FactoryBot.create(:crop, :radish)
        favorite_crop_path = favorite_crop.main_image_path
        user.user_setting.favorite_crops << favorite_crop
        login_as user
        visit user_path(:en, user.id)
        expect(page).to have_css "meta[property='og:image'][content='#{host_with_port}#{favorite_crop_path}']",
                                  visible: false
      end
    end

    context 'when favorite_crop is not present' do
      let(:user) { FactoryBot.create(:user, :with_user_setting) }
      it 'returns OpenFarm image' do
        image = 'openfarm-learn-to-grow-anything-with-community-created-guides'
        login_as user
        visit user_path(:en, user.id)
        meta = find("meta[property='og:image']", visible: false)
        expect(meta).to be
        expect(meta[:content]).to include(image)
      end
    end
  end
end
