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
    data = { stage: { name: Faker::Lorem.word,
                      soil: Faker::Lorem.words(2) },
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
    data = { stage: { instructions: "#{Faker::Lorem.sentences(2)}",
                      name: 'hello' },
             guide_id: 1 }
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
    put :update, id: stage.id, stage: { name: 'updated' }
    expect(response.status).to eq(200)
    stage.reload
    expect(stage.name).to eq('updated')
  end

  it 'cant create a stage on someone elses guide' do
    data = { stage: { instructions: "#{Faker::Lorem.sentences(2)}",
                      name: 'hello' },
             guide_id: FactoryGirl.create(:guide).id }
    post 'create', data, format: :json
    expect(json['error']).to include(
      "You can only create stages for guides that belong to you.")
    expect(response.status).to eq(401)
  end

  it 'should not update a stage on someone elses guide' do
    guide = FactoryGirl.create(:guide)
    stage = FactoryGirl.create(:stage, guide: guide)
    put :update, id: stage.id, stage: { overview: 'updated' }
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
    expect(json['error']).to include(
      'can only destroy stages that belong to your guides.')
    expect(response.status).to eq(401)
  end

  it 'handles deletion of unknown stages' do
    delete :destroy, id: 1
    expect(json['stage']).to eq('Could not find a stage with id 1.')
    expect(response.status).to eq(422)
  end

  it 'should add actions to stages'

  it 'should remove actions from stages'

  it 'should reject badly formed actions'

  it 'should only add actions to stages that the user owns the guide of'

  it 'should only remove actions from stages that the user owns the guide of'

  it 'should only update actions to stages that the user owns the guide of'
end
