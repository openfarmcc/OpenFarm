require 'spec_helper'
require 'openfarm_errors'

describe Stages::CreateStage do
  let(:mutation) { Stages::CreateStage }
  let(:guide) { FactoryGirl.create(:guide) }
  let(:params) do
    { user: guide.user,
      stage: { name: "#{Faker::Name.last_name}",
               order: 0 },
      guide_id: "#{guide._id}" }
  end

  it 'minimally requires a user and a guide to be true' do
    expect(mutation.run(params).success?).to be_true
  end

  it 'disallows making stages for guides that are not a users' do
    user = FactoryGirl.create(:user)
    params[:user] = user
    expect { mutation.run(params) }.to raise_exception
  end

  it 'creates a stage image via URL' do
    VCR.use_cassette('mutations/stages/update_stage') do
      image_params = params.merge(images: 'http://i.imgur.com/2haLt4J.jpg')
      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(1)
    end
  end

  it 'disallows phony URLs' do
    image_params = params.merge(images: 'iWroteThisWrong.net/2haLt4J.jpg')
    results = mutation.run(image_params)
    expect(results.success?).to be_false
    expect(results.errors.message[:images]).to include('not a valid URL')
  end

  it 'allows an empty stage actions array' do
    actions_params = params.merge(actions: [])
    results = mutation.run(actions_params)
    expect(results.success?).to be_true
  end

  it 'allows a well formed stage actions array' do
    actions = [{ name: "#{Faker::Lorem.word}",
                 overview: "#{Faker::Lorem.paragraph}" }]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.success?).to be_true
    expect(results.result.stage_actions.length).to eq(1)
  end

  it 'disallows a badly formed stage actions array' do
    actions = [{ name: "#{Faker::Lorem.word}",
                 description: "#{Faker::Lorem.paragraph}" },]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.success?).to be_false
    expect(results.errors.message[:actions]).to include('valid overview')
  end
end
