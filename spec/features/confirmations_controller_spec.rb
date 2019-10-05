# frozen_string_literal: true

require 'spec_helper'

class User
  attr_reader :raw_confirmation_token
end

RSpec.describe ConfirmationsController, type: :controller do
  def visit_user_confirmation_with_token(confirmation_token)
    visit user_confirmation_path(confirmation_token: confirmation_token)
  end

  context 'when confirmation token is valid' do
    context 'when user filled the required settings' do
      let(:user) { FactoryBot.create(:user, :with_user_setting) }
      it 'redirects to member profile page' do
        user.send_confirmation_instructions
        visit_user_confirmation_with_token(user.raw_confirmation_token)
        expect(response.status).to eq(200)
        expect(response).to render_template('users/show')
      end
    end
    context 'when user has not filled the required settings' do
      let(:user) { FactoryBot.create(:user) }
      it 'redirects to user details page' do
        user.send_confirmation_instructions
        visit_user_confirmation_with_token(user.raw_confirmation_token)
        expect(response.status).to eq(200)
        expect(response).to render_template('users/finish')
      end
    end
  end

  context 'when confirmation token is invalid' do
    it 'renders error page' do
      visit_user_confirmation_with_token('random_string')
      expect(response.status).to eq(200)
      expect(response).to render_template('devise/confirmations/new')
    end
  end
end
