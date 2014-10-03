require 'spec_helper'

describe Guides::CreateGuide do
  let(:cg) { Guides::CreateGuide }

  let(:params) do
    { user:    FactoryGirl.create(:user),
      crop_id: FactoryGirl.create(:crop).id.to_s,
      name:    'hi.',
      id:      FactoryGirl.create(:guide).id.to_s }
  end

  it 'requires fields' do
    errors = cg.run({}).errors.message_list
    expect(errors).to include('Name is required')
    expect(errors).to include('Crop is required')
    expect(errors).to include('User is required')
  end

  it 'grabs a blank guide from #guide' do
    expect(cg.new.guide).to be_a(Guide)
  end

  it 'validates invalid URLs' do
    # TODO We need to get Travis CI to actually work with this test. ENV vars
    # are broke.
    pending unless ENV['S3_BUCKET_NAME'].present?
    results = cg.run(params.merge(featured_image: 'not/absoloute.png'))
    message = results.errors.message_list.first
    expect(message).to include('Must be a fully formed URL')
    optns = { featured_image: 'http://placehold.it/1x1.png' }
    VCR.use_cassette('mutations/guides/create_guide.rb') do
      results = cg.run(params.merge(optns))
    end
    expect(results.success?).to be_true
    url = results.result.featured_image.url
    expect(url).to include('http://s3.amazonaws.com/')
  end

  it 'catches bad crop IDs' do
    params[:crop_id] = 'wrong'
    results = cg.run(params)
    message = results.errors.message_list.first
    expect(message).to include('Could not find a crop with id wrong.')
  end

  it 'creates valid guides' do
    result = cg.run(params).result
    expect(result).to be_a(Guide)
    expect(result.valid?).to be(true)
  end
end
