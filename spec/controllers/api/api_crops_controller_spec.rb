require "spec_helper"

describe Api::CropsController, :type => :controller do

  before do
    @beans = FactoryGirl.create(:crop, name: 'mung bean')
    FactoryGirl.create_list(:crop, 2)
  end

  it "lists crops." do
    get "index", format: :json, query: 'mung'
    expect(response.status).to eq(200)
    expect(json.length).to eq(1)
    expect(json['crops'][0]['_id']).to eq(@beans.id.to_s)
  end

  it 'returns [] for tiny searches' do
    get 'index', format: :json, query: 'mu'
    expect(response.status).to eq(200)
    expect(json).to eq('crops' => [])
  end
end
