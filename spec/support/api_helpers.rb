module ApiHelpers
  def json
    JSON.parse(response.body)
  end
end