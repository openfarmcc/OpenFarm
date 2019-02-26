require 'spec_helper'
require 'openfarm_errors'

describe Api::V1::TagsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    Crop.destroy_all
    FactoryBot.create(:crop, name: 'mung bean', tags: 'tagOne')
    FactoryBot.create(:crop, tags: 'tagTwo')
    Crop.searchkick_index.refresh
  end

  it 'lists tags' do
    skip 'this test does not pass on CI - RickCarlino'
    Legacy._get 'index', format: :json
    expect(response.status).to eq(200)
    expect(json.length).to eq(2)
    expect(json[0]).to eq('tagOne')
  end

  it 'returns the tag matching the query' do
    get 'index', format: :json, params: { query: 'one' }
    expect(response.status).to eq(200)
    expect(json.length).to eq(1)
    expect(json[0]).to eq('tagOne')
  end
end
