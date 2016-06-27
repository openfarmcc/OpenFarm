require 'spec_helper'

describe Api::V1::StagesController, type: :controller do
  include ApiHelpers

  let!(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  let(:guide) { FactoryGirl.create(:guide, user: user) }
  let(:stage) { FactoryGirl.create(:stage, guide: user) }

  before do
    @guide = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
  end

  it 'creates stages' do
    guide = FactoryGirl.create(:guide, user: user)
    old_length = Stage.all.length
    data = { attributes: { name: Faker::Lorem.word,
                           order: 0,
                           soil: Faker::Lorem.words(2) },
             guide_id: guide.id.to_s }
    post 'create', data: data, format: :json
    expect(response.status).to eq(201)
    new_length = Stage.all.length
    expect(json['data']['attributes']['name']).to eq(data[:attributes][:name])
    expect(json['data']['attributes']['soil']).to eq(data[:attributes][:soil])
    expect(new_length).to eq(old_length + 1)
  end

  it 'should return an error when wrong info is passed to create' do
    # FIXME what is this spec testing? Maybe we should do some assertions on
    # the response message.
    data = {
      instructions: "#{Faker::Lorem.paragraph}",
      guide_id: guide.id.to_s
    }
    post 'create', data: data, format: :json
    expect(response.status).to eq(422)
  end

  it 'should return an error when a guide does not exist' do
    data = { attributes: { instructions: "#{Faker::Lorem.sentences(2)}",
                           name: 'hello',
                           order: 0 },
             guide_id: 1 }
    post 'create', data: data, format: :json
    error = json['errors'][0]
    expect(error['title']).to eq('Could not find a guide with id 1.')
    expect(response.status).to eq(422)
  end

  it 'should show a specific stage' do
    stage = FactoryGirl.create(:stage)
    get 'show', id: stage.id, format: :json
    expect(response.status).to eq(200)
    expect(json['data']['attributes']['name']).to eq(stage.name)
  end

  it 'should update a stage' do
    guide = FactoryGirl.create(:guide, user: user)
    stage = FactoryGirl.create(:stage, guide: guide)
    data = { attributes: { name: 'updated' } }
    put :update, id: stage.id, data: data
    expect(response.status).to eq(200)
    stage.reload
    expect(stage.name).to eq('updated')
  end

  it 'cant create a stage on someone elses guide' do
    data = { attributes: { instructions: "#{Faker::Lorem.sentences(2)}",
                           name: 'hello',
                           order: 0 },
             guide_id: FactoryGirl.create(:guide).id.to_s }
    post 'create', data: data, format: :json
    expect(json['errors'][0]['title']).to include(
      "You can only create stages for guides that belong to you.")
    expect(response.status).to eq(401)
  end

  it 'should not update a stage on someone elses guide' do
    guide = FactoryGirl.create(:guide)
    stage = FactoryGirl.create(:stage, guide: guide)
    data = { attributes: { overview: 'updated' } }
    put :update, id: stage.id, data: data
    expect(response.status).to eq(401)
    expect(response.body).to include('You can only update stages that belong to your guides.')
  end

  it 'deletes stages' do
    guide = FactoryGirl.create(:guide, user: user)
    stage = FactoryGirl.create(:stage, guide: guide)
    old_length = Stage.all.length
    delete 'destroy', id: stage.id, format: :json
    new_length = Stage.all.length
    expect(new_length).to eq(old_length - 1)
  end

  it 'only destroys stages owned by the user' do
    delete :destroy, id: FactoryGirl.create(:stage)
    expect(json['errors'][0]['title']).to include(
      'can only destroy stages that belong to your guides.')
    expect(response.status).to eq(401)
  end

  it 'handles deletion of unknown stages' do
    delete :destroy, id: 1
    errors = json['errors']
    expect(errors[0]['title']).to eq('Could not find a stage with id 1.')
    expect(response.status).to eq(422)
  end

  it 'has a picture route, which returns empty when there are no pictures' do
    get :pictures, stage_id: FactoryGirl.create(:stage).id.to_s
    expect(json['data'].count).to eq(0)
  end

  it 'has a picture route, which returns with pictures' do
    VCR.use_cassette('controllers/api/api_stages_controller') do
      stage = FactoryGirl.create(:stage)
      Picture.from_url('http://i.imgur.com/2haLt4J.jpg', stage)
      stage.reload
      get :pictures, stage_id: stage.id
      expect(json['data'].count).to eq(1)
    end
  end

  it 'should add actions in a stage creation event successfully' do
    data = { attributes: { instructions: "#{Faker::Lorem.paragraph}",
                           name: 'hello',
                           order: 0 },
             actions: [{ name: "#{Faker::Lorem.word}",
                         overview: "#{Faker::Lorem.paragraph}" }],
             guide_id: guide.id.to_s }
    post 'create', data: data, format: :json
    expect(response.status).to eq(201)
  end

  it 'should remove actions from stages'

  it 'should reject stage actions without a name' do
    data = { attributes: { instructions: "#{Faker::Lorem.paragraph}",
                           name: 'hello',
                           order: 0 },
             actions: [{ name: '' }],
             guide_id: guide.id.to_s }
    post 'create', data: data, format: :json
    expect(response.status).to eq(422)
    expect(response.body).to include('not a valid action name')
  end

  it 'should accept stage actions without an overview' do
    data = { attributes: { instructions: "#{Faker::Lorem.paragraph}",
                           name: 'hello',
                           order: 0 },
             actions: [{ name: 'hello' }],
             guide_id: guide.id.to_s }
    post 'create', data: data, format: :json
    expect(response.status).to eq(201)
  end

  it 'should only add actions to stages that the user owns the guide of'

  it 'should only remove actions from stages that the user owns the guide of'

  it 'should only update actions to stages that the user owns the guide of'
end
