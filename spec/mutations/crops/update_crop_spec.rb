require 'spec_helper'
require 'openfarm_errors'

describe Crops::UpdateCrop do
  let(:mutation) { Crops::UpdateCrop }

  let(:user) { FactoryGirl.create(:user) }
  let(:crop) { FactoryGirl.create(:crop) }

  let(:params) do
    { user: user,
      id: "#{crop.id}",
      crop: { binomial_name: 'updated',
              description: 'A random description' } }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('Crop is required')
    expect(errors).to include('Id is required')
  end

  it 'updates valid crops' do
    result = mutation.run(params).result
    expect(result).to be_a(Crop)
    expect(result.valid?).to be(true)
  end

  it 'updates a crop image via URL' do
    VCR.use_cassette('mutations/crops/update_stage') do
      image_hash = {
        image_url: 'http://i.imgur.com/2haLt4J.jpg'
      }
      image_params = params.merge(images: [ image_hash ])
      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(1)
    end
  end

  it 'disallows phony URLs' do
    image_hash = {
      image_url: 'iWroteThisWrong.net/2haLt4J.jpg'
    }
    image_params = params.merge(images: [ image_hash ])
    results = mutation.run(image_params)
    expect(results.success?).to be_false
    expect(results.errors.message[:images]).to include('not a valid URL')
  end

  it 'uploads multiple images' do
    # pending 'Bucket not set :(' unless ENV['S3_BUCKET_NAME'].present?
    VCR.use_cassette('mutations/crops/update_stage') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' },
                    { image_url: 'http://i.imgur.com/kpHLl.jpg' }]
      image_params = params.merge(images: image_hash)
      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(2)
      # This is no longer guaranteed because on localhost
      # things run on the file system, not on amazon.
      # expect(pics.first.attachment.url.valid_url?).to be_true
    end
  end

  it 'deletes images marked for deletion' do
    # pending 'Bucket not set :(' unless ENV['S3_BUCKET_NAME'].present?
    VCR.use_cassette('mutations/crops/update_stage') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' }]

      image_params = params.merge(images: image_hash)
      results = mutation.run(image_params)

      image_hash = []

      image_params[:images] = image_hash

      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(0)
    end
  end

  it 'leaves existing images as is' do
    # pending 'Bucket not set :(' unless ENV['S3_BUCKET_NAME'].present?
    VCR.use_cassette('mutations/crops/update_stage') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' }]

      image_params = params.merge(images: image_hash)
      results = mutation.run(image_params)

      crop.reload

      image_hash = [{ image_url: crop.pictures.first.attachment.url,
                      id: crop.pictures.first.id },
                    { image_url: 'http://i.imgur.com/kpHLl.jpg' }]

      image_params[:images] = image_hash

      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(2)
      # This is no longer guaranteed because on localhost
      # things run on the file system, not on amazon.
      # expect(pics.first.attachment.url.valid_url?).to be_true
      # expect(pics[1].attachment.url.valid_url?).to be_true
    end
  end

  it 'leaves existing images as is' do
    # pending 'Bucket not set :(' unless ENV['S3_BUCKET_NAME'].present?
    VCR.use_cassette('mutations/crops/update_stage') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' }]

      image_params = params.merge(images: image_hash)
      results = mutation.run(image_params)

      crop.reload

      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg',
                      id: crop.pictures.first.id },
                    { image_url: 'http://i.imgur.com/kpHLl.jpg' }]

      image_params[:images] = image_hash

      results = mutation.run(image_params)
      expect(results.success?).to be_false
      expect(results.errors.message[:images]).to include('existing image')
    end
  end
end
