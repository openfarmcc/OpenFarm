require 'spec_helper'

describe Stages::UpdateStage do
  let(:mutation) { Stages::UpdateStage }

  let(:stage) { FactoryGirl.create(:stage) }

  let(:params) do
    { user: stage.guide.user,
      stage: stage,
      attributes: { } }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('User is required')
    expect(errors).to include('Stage is required')
  end

  it 'minimally requires a user and a stage' do
    expect(mutation.run(params).success?).to be_true
  end

  it 'updates a stage image via URL' do
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
    expect(results.errors.message[:images]).to include("not a valid URL")
  end

  it 'allows an empty stage actions array' do
    actions_params = params.merge(actions: [])
    results = mutation.run(actions_params)
    expect(results.success?).to be_true
  end

  it 'allows a well formed stage actions array' do
    actions = [ { name: "#{Faker::Lorem.word}",
                  overview: "#{Faker::Lorem.paragraph}" }, ]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.success?).to be_true
    expect(results.result.stage_actions.length).to eq(1)
  end

  it 'disallows a badly formed stage actions array with bad overview' do
    actions = [ { name: "#{Faker::Lorem.word}",
                  description: "#{Faker::Lorem.paragraph}" }, ]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.success?).to be_false
    expect(results.errors.message[:actions]).to include('valid overview')
  end

  it 'disallows a badly formed stage actions array with bad name' do
    actions = [ { moon: "#{Faker::Lorem.word}",
                  overview: "#{Faker::Lorem.paragraph}" }, ]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.success?).to be_false
    expect(results.errors.message[:actions]).to include('valid name')
  end
end
