require 'spec_helper'

describe Api::StagesController, type: :controller do

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
    data = { name: Faker::Lorem.word,
             instructions: "#{Faker::Lorem.sentences(2)}",
             guide_id: guide.id }
    post 'create', data, format: :json
    expect(response.status).to eq(201)
    new_length = Stage.all.length
    expect(new_length).to eq(old_length + 1)
  end

  it 'should return an error when wrong info is passed to create' do
    # FIXME what is this spec testing? Maybe you should do some assertions on
    # the response message.
    data = {
      instructions: "#{Faker::Lorem.sentences(2)}",
      guide_id: guide.id
    }
    post 'create', data, format: :json
    expect(response.status).to eq(422)
  end

  it 'should return an error when a guide is not provided' do
    data = { instructions: "#{Faker::Lorem.sentences(2)}",
             guide_id: 1,
             name: 'hello' }
    post 'create', data, format: :json
    expect(json['guide_id']).to eq("Could not find a guide with id 1.")
    expect(response.status).to eq(422)
  end

  it 'should show a specific stage' do
    stage = FactoryGirl.create(:stage)
    get 'show', id: stage.id, format: :json
    expect(response.status).to eq(200)
    expect(json['stage']['name']).to eq(stage.name)
  end

  it 'should update a stage' do
    guide = FactoryGirl.create(:guide, user: user)
    stage = FactoryGirl.create(:stage, guide: guide)
    put :update, id: stage.id, instructions: 'updated'
    expect(response.status).to eq(200)
    stage.reload
    expect(stage.instructions).to eq('updated')
  end

  it 'cant create a stage on someone elses guide' do
    data = { instructions: "#{Faker::Lorem.sentences(2)}",
             guide_id: FactoryGirl.create(:guide).id,
             name: 'hello' }
    post 'create', data, format: :json
    expect(json['error']).to include(
      "You can only create stages for guides that belong to you.")
    expect(response.status).to eq(401)
  end

  it 'should not update a stage on someone elses guide' do
    guide = FactoryGirl.create(:guide)
    stage = FactoryGirl.create(:stage, guide: guide)
    put :update, id: stage.id, overview: 'updated'
    expect(response.status).to eq(401)
    expect(response.body).to include('You can only update stages that belong to your guides.')
  end
end
