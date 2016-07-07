require 'spec_helper'

RSpec.describe ConfirmationsController, :type => :controller do

  it 'confirmation_token is valid' do
    sign_in user
    get :show, confirmation_token: user.confirmation_token
    it 'if the user has filled in necessary details'
        user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
        usetting = UserSetting.create(location: 'India', units: 'Imperial')
        usetting.user = user
        get :show, confirmation_token: user.confirmation_token
        expect(user.has_filled_required_settings?).to be true
        it 'redirects to member profile page' do
            user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
            usetting = UserSetting.create(location: 'India', units: 'Imperial')
            usetting.user = user
            usetting.save
            get :show, confirmation_token: user.confirmation_token
            expect(response).to redirect_to(url_for(controller: 'users',
                                                    action: 'show',
                                                    id: user))
        end
    end
    it 'if the user has not filled in the location' do
        user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
        usetting = UserSetting.create(location: nil, units: 'Imperial')
        usetting.user = user
        get :show, confirmation_token: user.confirmation_token
        expect(user.has_filled_required_settings?).to be false
        it 'redirects to user details page' do
            user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
            usetting = UserSetting.create(location: nil, units: 'Imperial')
            usetting.user = user
            usetting.save
            get :show, confirmation_token: user.confirmation_token
            expect(response).to redirect_to(url_for(controller: 'users',
                                                    action: 'finish',
                                                    id: user))
        end
    end
    it 'if the user has not filled in the units' do
        user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
        usetting = UserSetting.create(location: 'India', units: nil)
        usetting.user = user
        get :show, confirmation_token: user.confirmation_token
        expect(user.has_filled_required_settings?).to be false
        it 'redirects to user details page' do
            user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
            usetting = UserSetting.create(location: 'India', units: nil)
            usetting.user = user
            usetting.save
            get :show, confirmation_token: user.confirmation_token
            expect(response).to redirect_to(url_for(controller: 'users',
                                                    action: 'finish',
                                                    id: user))
        end
    end
    it 'if the user has neither filled the location nor the units' do
        user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
        usetting = UserSetting.create(location: nil, units: nil)
        usetting.user = user
        get :show, confirmation_token: user.confirmation_token
        expect(user.has_filled_required_settings?).to be false
        it 'redirects to user details page' do
            user = User.create(email: "admin@example.com", password: "password123", display_name: "testname")
            usetting = UserSetting.create(location: nil, units: nil)
            usetting.user = user
            usetting.save
            get :show, confirmation_token: user.confirmation_token
            expect(response).to redirect_to(url_for(controller: 'users',
                                                    action: 'finish',
                                                    id: user))
        end
    end
  end

  it 'should show the user new confirmations page' do
    sign_in user
    get :show, confirmation_token: 'da'
    expect(response).to render_template('/devise/confirmations/new')
  end
end
