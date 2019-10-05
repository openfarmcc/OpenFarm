# frozen_string_literal: true

module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def make_api_user
    token = FactoryBot.create(:token)
    set_token(token)
    token.user
  end

  def set_token(token)
    controller.request.env['HTTP_AUTHORIZATION'] =
      'Token token=' \
        "#{token.fully_formed}"
  end

  def note(msg)
    SmarfDoc.note msg.squish
  end
end
