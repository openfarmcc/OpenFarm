require "spec_helper"

describe Api::CropsController, :type => :controller do

  before do
    @beans = FactoryGirl.create(:crop, name: 'mung bean')
    FactoryGirl.create_list(:crop, 2)
    Crop.searchkick_index.refresh
  end

  it 'lists crops.' do
    get 'index', format: :json, query: 'mung'
    expect(response.status).to eq(200)
    expect(json.length).to eq(1)
    expect(json['crops'][0]['_id']).to eq(@beans.id.to_s)
  end

  it 'returns [] for tiny searches' do
    DocYoSelf.skip
    get 'index', format: :json, query: 'mu'
    expect(response.status).to eq(200)
    expect(json).to eq('crops' => [])
  end

  it 'should show a crop' do
    crop = FactoryGirl.create(:crop)
    get 'show', format: :json, id: crop.id
    expect(response.status).to eq(200)
    expect(json['crop']['name']).to eq(crop.name)
  end

  it 'should return a 404 when a crop doesn\'t exist'
end
