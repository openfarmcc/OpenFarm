require 'spec_helper'

describe Stages::CreateStage do
  let(:mutation) { Stages::CreateStage }
  let(:guide) { FactoryGirl.create(:guide) }
  let(:params) { { user: guide.user,
                   name: "#{Faker::Name.last_name}",
                   guide_id: "#{guide._id}" } }

  it 'minimally requires a user and a guide to be true' do
    expect(mutation.run(params).success?).to be_true
  end

  it 'creates a stage image via URL' do
    VCR.use_cassette('mutations/stages/update_stage') do
      image_params = params.merge(images: 'http://i.imgur.com/2haLt4J.jpg')
      results      = mutation.run(image_params)
      pics = results.result.pictures
      expect(pics.count).to eq(1)
      expect(pics.first.attachment.url.valid_url?).to be_true
    end
  end

  it 'disallows phony URLs' do
    image_params = params.merge(images: 'iWroteThisWrong.net/2haLt4J.jpg')
    results      = mutation.run(image_params)
    expect(results.success?).to be_false
    expect(results.errors.message[:images]).to include("not a valid URL")
  end

end
