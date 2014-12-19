require 'spec_helper'

describe Picture do
  it 'has an attachment' do
    VCR.use_cassette('models/pictures_spec-1.rb') do
      stage = FactoryGirl.create(:stage)
      pic = Picture.from_url('http://placehold.it/1x1.jpg', stage)
      stage.save
      img_url = stage.pictures.first.attachment.url
      expect(img_url).to include('attachments')
    end
  end
end
