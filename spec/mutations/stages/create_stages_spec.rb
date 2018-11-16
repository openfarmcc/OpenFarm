require 'spec_helper'
require 'openfarm_errors'

describe Stages::CreateStage do
  let(:mutation) { Stages::CreateStage }
  let(:guide) { FactoryBot.create(:guide) }
  let(:params) do
    { user: guide.user,
      attributes: { name: "#{Faker::Name.last_name}",
                    order: 0 },
      guide_id: "#{guide._id}" }
  end

  it 'minimally requires a user and a guide to be true' do
    expect(mutation.run(params).success?).to be_truthy
  end

  it 'disallows making stages for guides that are not a users' do
    user = FactoryBot.create(:user)
    params[:user] = user
    expect { mutation.run(params) }.to raise_exception(OpenfarmErrors::NotAuthorized)
  end

  it 'creates a stage image via URL' do
    VCR.use_cassette('mutations/stages/create_stage') do
      image_hash = {
        image_url: 'http://i.imgur.com/2haLt4J.jpg'
      }
      image_params = params.merge(images: [image_hash])
      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(1)
    end
  end

  it 'disallows phony URLs' do
    image_hash = {
      image_url: 'iWroteThisWrong.net/2haLt4J.jpg'
    }
    image_params = params.merge(images: [image_hash])
    results = mutation.run(image_params)
    expect(results.success?).to be_falsey
    expect(results.errors.message[:images]).to include('not a valid URL')
  end

  it 'uploads multiple images' do
    VCR.use_cassette('mutations/stages/create_stage') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' },
                    { image_url: 'http://i.imgur.com/kpHLl.jpg' }]
      image_params = params.merge(images: image_hash)
      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(2)
    end
  end

  it 'allows an empty stage actions array' do
    actions_params = params.merge(actions: [])
    results = mutation.run(actions_params)
    expect(results.success?).to be_truthy
  end

  it 'allows a well formed stage actions array' do
    actions = [{ name: "#{Faker::Lorem.word}",
                 overview: "#{Faker::Lorem.paragraph}" }]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.success?).to be_truthy
    expect(results.result.stage_actions.length).to eq(1)
  end

  it 'allows a well formed stage actions array with order' do
    actions = [{ name: "#{Faker::Lorem.word}",
                 overview: "#{Faker::Lorem.paragraph}",
                 order: 1 },
               { name: "#{Faker::Lorem.word}",
                 overview: "#{Faker::Lorem.paragraph}",
                 order: 2 }]
    actions_params = params.merge(actions: actions)
    results = mutation.run(actions_params)
    expect(results.result.stage_actions[0][:order]).to eq(1)
    expect(results.success?).to be_truthy
    expect(results.result.stage_actions.length).to eq(2)
  end

  it 'allows images in stage actions' do
    VCR.use_cassette('mutations/stages/create_stage') do
      actions = [{ name: "#{Faker::Lorem.word}",
                   overview: "#{Faker::Lorem.paragraph}",
                   order: 1,
                   images: [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' },
                            { image_url: 'http://i.imgur.com/kpHLl.jpg' }]
                    },
                 { name: "#{Faker::Lorem.word}",
                   overview: "#{Faker::Lorem.paragraph}",
                   order: 2 }]
      actions_params = params.merge(actions: actions)
      results = mutation.run(actions_params)
      expect(results.success?).to be_truthy
      expect(results.result.stage_actions[0].pictures.length).to eq(2)
    end
  end
end
