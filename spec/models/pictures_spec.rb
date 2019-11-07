require 'spec_helper'

describe Picture do
  it 'has an attachment' do
    VCR.use_cassette('models/pictures_spec-1.rb') do
      stage = FactoryBot.create(:stage)
      pic = Picture.from_url('http://placehold.it/1x1.jpg', stage)
      stage.reload
      img_url = stage.pictures.first.attachment.url
      expect(img_url).to include('attachments')
    end
  end

  it 'reports failed image processing' do
    data = {
      data: {
        file_location: '/home/rick/code/farmbot/OpenFarm/public/***',
        parent: {}
      }
    }
    get_errors = receive(:notify_exception)
      .with(an_instance_of(Errno::ENOENT), data)
      expect(ExceptionNotifier).to get_errors
      expect do
        Picture.from_url('***', {})
      end.to raise_error(Errno::ENOENT)
  end
end
