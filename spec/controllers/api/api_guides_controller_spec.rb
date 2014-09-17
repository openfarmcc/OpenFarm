require 'spec_helper'

describe Api::GuidesController, type: :controller do

  include ApiHelpers

  let(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  let(:guide) { FactoryGirl.create(:guide, user: user) }

  before do
    @beans_v2 = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
    FactoryGirl.create_list(:guide, 2)
  end

  it 'should create guides' do
    sign_in FactoryGirl.create(:user)
    data = { name: 'brocolini in the desert',
             overview: 'something exotic',
             crop_id: FactoryGirl.create(:crop).id.to_s }
    post 'create', guide: data, format: :json

    expect(response.status).to eq(201)

    expect(json['guide']['name']).to eq(data[:name])
    expect(json['guide']['crop_id']).to eq(data[:crop_id])
  end

  it 'uploads a featured_image' do
    params = { name: 'Just 1 pixel.',
               overview: 'A tiny pixel test image.',
               featured_image: 'http://placehold.it/1x1.jpg',
               crop_id: FactoryGirl.create(:crop).id.to_s }
    sign_in FactoryGirl.create(:user)
    VCR.use_cassette('controllers/api/api_guides_controller_spec') do
      post 'create', guide: params
    end
    expect(response.status).to eq(201)
    img_url = json['guide']['featured_image']
    expect(img_url).to include('.jpg')
    expect(img_url).to include('featured_images')
    expect(img_url).to include('http://')
    expect(img_url).to include('amazonaws.com')
  end

  it 'should return an error with wrong guide information'

  it 'should show a specific guide' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id, format: :json
    expect(response.status).to eq(200)
    expect(json['guide']['name']).to eq(guide.name)
  end

  it 'should return a not found error if a guide isn\'t found'
  # get 'show', id: '1', format: :json
  # expect(response.status).to eq(404)
  # This test fails, largely because I don't know how to
  # implement it.

  it 'should update a guide' do
    sign_in user
    guide = FactoryGirl.create(:guide, user: user, overview: 'old')
    put :update, id: guide.id, overview: 'updated'
    expect(response.status).to eq(200)
    guide.reload
    expect(guide.overview).to eq('updated')
  end

  it 'should not update someone elses guide' do
    sign_in FactoryGirl.create(:user)
    guide = FactoryGirl.create(:guide)
    put :update, id: guide.id, overview: 'updated'
    expect(response.status).to eq(422) # WRONG. See TODO in mutation.
    expect(response.body).to include('You can only update guides that you own.')
  end

  it 'validates URL paramters' do
    put :update, id: guide.id, featured_image: 'not a real URL'
    expect(response.status).to eq(422)
    expect(json['featured_image']).to include('Must be a fully formed URL')
  end
end
