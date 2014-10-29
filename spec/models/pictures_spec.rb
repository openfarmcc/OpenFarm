require 'spec_helper'

describe Picture do
  it 'has an attachment' do
    pending 'Bucket not set :(' unless ENV['S3_BUCKET_NAME'].present?
    pic = Picture.from_url('http://placehold.it/1x1.jpg')
    stage = FactoryGirl.create(:stage)
    stage.pictures << pic
    VCR.use_cassette('models/pictures_spec.rb') do
      stage.save
    end
    img_url = stage.pictures.first.attachment.url
    expect(img_url).to include('attachments')
    expect(img_url).to include('http://')
    expect(img_url).to include('amazonaws.com')
  end
end
