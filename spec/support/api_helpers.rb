module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def make_api_user
    token = FactoryGirl.create(:token)
    set_token(token)
    return token.user
  end

  def set_token(token)
    controller.request.env['HTTP_AUTHORIZATION'] = "Token token="\
                                                   "#{token.fully_formed}"
  end
end