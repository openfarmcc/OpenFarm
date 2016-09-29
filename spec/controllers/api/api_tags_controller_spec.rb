require 'spec_helper'
require 'openfarm_errors'

describe Api::V1::TagsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  before do
    FactoryGirl.create(:crop, name: 'mung bean', tags: 'tagOne')
    FactoryGirl.create(:crop, tags: 'tagTwo')
    Crop.searchkick_index.refresh
  end

  it 'lists tags' do
    get 'index', format: :json
    expect(response.status).to eq(200)
    expect(json['tags'].length).to eq(2)
    expect(json['tags'][0]).to eq('tagOne')
  end

  it 'returns the tag matching the query' do
    get 'index', format: :json, query: 'on'
    expect(response.status).to eq(200)
    expect(json['tags'].length).to eq(1)
    expect(json['tags'][0]).to eq('tagOne')
  end
end
