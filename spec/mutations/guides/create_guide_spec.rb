require 'spec_helper'

describe Guides::CreateGuide do
  let(:cg) { Guides::CreateGuide }

  let(:params) do
    { user:    FactoryGirl.create(:user),
      crop_id: FactoryGirl.create(:crop).id.to_s,
      id:      FactoryGirl.create(:guide).id.to_s,
      attributes: { name:    'hi.' }
    }
  end

  it 'requires fields' do
    errors = cg.run({}).errors.message_list
    expect(errors).to include('Attributes is required')
    expect(errors).to include('User is required')
  end

  it 'requires a name' do
    params[:attributes] = {}
    errors = cg.run(params).errors.message_list
    expect(errors).to include('Name is required')
  end

  it 'validates invalid URLs' do
    attributes = params[:attributes]
    attributes[:featured_image] = 'not/absoloute.png'
    results = cg.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Must be a fully formed URL')
    attributes[:featured_image] = 'http://placehold.it/1x1.png'
    VCR.use_cassette('mutations/guides/create_guide.rb') do
      results = cg.run(params)
    end
    expect(results.success?).to be_truthy
  end

  it 'catches bad crop IDs' do
    params[:crop_id] = 'wrong'
    results = cg.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a crop with id wrong')
  end

  it 'creates valid guides' do
    result = cg.run(params).result
    expect(result).to be_a(Guide)
    expect(result.valid?).to be(true)
  end

  it 'catches invalid practices' do
    params[:attributes][:practices] = ['string', 8, 'string']
    results = cg.run(params)
    message = results.errors.message_list.first
    expect(message).to include('8 is not a valid practice.')
  end

  it 'knows to choose a crop based on a crop name' do
    params.except!(:crop_id)
    params[:crop_name] = FactoryGirl.create(:crop).name
    result = cg.run(params).result
    expect(result).to be_a(Guide)
    expect(result.valid?).to be(true)
  end

  it 'creates an associated timespan object' do
    params[:attributes][:time_span] = {
      start_event: 20,
      start_event_format: '%W',
      length: 24,
      length_units: 'weeks'
    }
    results = cg.run(params)
    expect(results.success?).to be_truthy
    expect(results.result[:time_span]['length_units']).to include('weeks')
    expect(results.result[:time_span]['start_event']).to eq('20')
    expect(results.result[:time_span]['length']).to eq('24')
    expect(results.result[:time_span]['start_event_format']).to include('%W')
  end
end
