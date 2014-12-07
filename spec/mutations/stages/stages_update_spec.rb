require 'spec_helper'

describe Guides::CreateGuide do
  let(:mutation) { Stages::UpdateStage }
  let(:stage) { FactoryGirl.create(:stage) }
  let(:params) { { user: stage.guide.user, stage: stage } }

  it 'minimally requires a user and a stage' do
    expect(mutation.run(params).success?).to be_true
  end

  it 'updates a stage image via URL' do
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
    expect(results.errors.message[:images]).to include('not a valid URL')
  end

end
