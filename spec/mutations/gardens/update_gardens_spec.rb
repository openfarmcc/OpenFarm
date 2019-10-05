require 'spec_helper'

describe Gardens::UpdateGarden do
  let(:mutation) { Gardens::UpdateGarden }

  let(:garden) { FactoryBot.create(:garden) }

  let(:params) { { user: garden.user, id: "#{garden._id}", attributes: {} } }

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('User is required')
    expect(errors).to include('Attributes is required')
  end

  it 'minimally requires a user and a garden' do
    expect(mutation.run(params).success?).to be_truthy
  end

  it 'tests this' do
    attributes = {
      'name' => 'The Hanoi Balcony',
      'location' => 'Inside',
      'description' =>
        "We created this garden automatically to get\nyou started. You can edit it to better suit\nyour needs!",
      'type' => 'Inside',
      'average_sun' => 'Full Sun',
      'soil_type' => 'Loam',
      'ph' => 7.5
    }
    params = { user: garden.user, id: "#{garden._id}", attributes: attributes }
    expect(mutation.run(params).success?).to be_truthy
  end

  it 'updates a garden image via URL' do
    VCR.use_cassette('mutations/gardens/update_garden') do
      image_hash = { image_url: 'http://i.imgur.com/2haLt4J.jpg' }
      image_params = params.merge(images: [image_hash])
      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(1)
    end
  end

  it 'disallows phony URLs' do
    image_hash = { image_url: 'iWroteThisWrong.net/2haLt4J.jpg' }
    image_params = params.merge(images: [image_hash])
    results = mutation.run(image_params)
    expect(results.success?).to be_falsey
    expect(results.errors.message[:images]).to include('not a valid URL')
  end

  it 'deletes images marked for deletion' do
    VCR.use_cassette('mutations/gardens/update_garden') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' }]

      image_params = params.merge(images: image_hash)
      mutation.run(image_params)

      image_hash = []

      image_params[:images] = image_hash

      results = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(0)
    end
  end

  it 'does not edit existing images' do
    VCR.use_cassette('mutations/gardens/update_garden') do
      image_hash = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' }]

      image_params = params.merge(images: image_hash)
      mutation.run(image_params)

      garden.reload

      image_hash = [
        { image_url: 'http://i.imgur.com/2haLt4J.jpg', id: garden.pictures.first.id },
        { image_url: 'http://i.imgur.com/kpHLl.jpg' }
      ]

      image_params[:images] = image_hash

      results = mutation.run(image_params)
      expect(results.success?).to be_falsey
      expect(results.errors.message[:images]).to include('existing image')
    end
  end
end
