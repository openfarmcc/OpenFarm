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
    data = {:data=>{:file_location=>"***", :parent=>{}}}
    error = an_instance_of(Errno::ENOENT)
    get_errors = receive(:notify_exception).with(error, data).and_return(nil)
    expect(ExceptionNotifier).to(get_errors)
    expect_error = expect { Picture.from_url('***', {}) }
    expect_error.to raise_error(Errno::ENOENT)
  end
end
