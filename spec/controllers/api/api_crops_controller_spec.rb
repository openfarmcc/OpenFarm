require "spec_helper"

describe Api::CropsController, :type => :controller do

  let(:user) { FactoryGirl.create(:user) }

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

  it 'should update a crop' do
    sign_in user
    crop = FactoryGirl.create(:crop)
    put :update, id: crop.id, crop: { description: 'Updated' }
    expect(response.status).to eq(200)
    crop.reload
    expect(crop.description).to eq('Updated')
  end

  it 'should return an error when updating faulty information' do
    sign_in user
    crop = FactoryGirl.create(:crop)
    put :update, id: crop.id, crop: { description: '' }
    expect(response.status).to eq(422)
    old_description = crop.description
    crop.reload
    expect(crop.description).to eq(old_description)
  end
end
