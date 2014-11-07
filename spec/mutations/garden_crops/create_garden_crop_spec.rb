require 'spec_helper'
require 'openfarm_errors'

describe GardenCrops::CreateGardenCrop do
  let(:cgc) { GardenCrops::CreateGardenCrop }

  let(:user) { FactoryGirl.create(:user) }

  let(:params) do
    { user:      user,
      garden_id: FactoryGirl.create(:garden, user: user).id.to_s,
      stage:      "#{Faker::Lorem.word}",
      sowed:     "#{Faker::Date.between(2.days.ago, Date.today)}",
      quantity:  rand(100) }
  end

  it 'requires fields' do
    errors = cgc.run({}).errors.message_list
    expect(errors).to include('Garden is required')
    expect(errors).to include('User is required')
  end

  it 'grabs a blank garden_crop from #garden_crop' do
    expect(cgc.new.garden_crop).to be_a(GardenCrop)
  end

  it 'catches bad garden IDs' do
    params[:garden_id] = 'wrong'
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a garden with id wrong.')
  end

  it 'catches bad guide IDs' do
    params[:guide_id] = 'wrong'
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a guide with id wrong.')
  end

  it 'catches creating gardens not owned by user' do
    params[:garden_id] = FactoryGirl.create(:garden).id.to_s
    results = cgc.run(params)
    message = results.errors.message_list.first
    expect(message).to include('for gardens you don\'t own.')
  end

  it 'creates valid garden crops' do
    result = cgc.run(params).result
    expect(result).to be_a(GardenCrop)
    expect(result.valid?).to be(true)
  end
end
