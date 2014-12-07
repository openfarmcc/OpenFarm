require 'spec_helper'

describe Picture do
  it 'has an attachment' do
    pending 'Bucket not set :(' unless ENV['S3_BUCKET_NAME'].present?
    VCR.use_cassette('models/pictures_spec-1.rb') do
      stage = FactoryGirl.create(:stage)
      Picture.from_url('http://placehold.it/1x1.jpg', stage)    # pic
      stage.save
      img_url = stage.pictures.first.attachment.url
      expect(img_url).to include('attachments')
      expect(img_url).to include('http://')
      expect(img_url).to include('amazonaws.com')
    end
  end
end
