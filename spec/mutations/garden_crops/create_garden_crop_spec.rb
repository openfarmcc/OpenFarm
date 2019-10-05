# frozen_string_literal: true

require 'spec_helper'
require 'openfarm_errors'

describe GardenCrops::CreateGardenCrop do
  let(:cgc) { GardenCrops::CreateGardenCrop }

  let(:user) { FactoryBot.create(:user) }

  let(:params) do
    {
      user: user,
      garden_id: FactoryBot.create(:garden, user: user).id.to_s,
      attributes: {
        stage: "#{Faker::Lorem.word}",
        sowed: "#{Faker::Date.between(2.days.ago, Date.today)}",
        quantity: rand(100),
        guide: FactoryBot.create(:guide).id.to_s
      }
    }
  end

  it 'requires fields' do
    errors = cgc.run({}).errors.message_list
    expect(errors).to include('Garden ID is required')
    expect(errors).to include('User is required')
  end

  it 'catches bad garden IDs' do
    params[:garden_id] = 'wrong'
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a garden with id wrong.')
  end

  it 'catches bad guide IDs' do
    params[:attributes][:guide] = 'wrong'
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a guide with id wrong.')
  end

  it 'catches bad crop IDs' do
    params[:attributes][:crop] = 'wrong'
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a crop with id wrong.')
  end

  it 'catches creating gardens not owned by user' do
    params[:garden_id] = FactoryBot.create(:garden).id.to_s
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include("for gardens you don't own.")
  end

  it 'catches that there is no crop or guide attached' do
    params[:attributes][:guide] = nil
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('You need either a guide or a crop')
  end
end
