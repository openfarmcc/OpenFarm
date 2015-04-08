require 'spec_helper'

describe Users::UpdateUser do
  let(:mutation) { Users::UpdateUser }

  let(:user) { FactoryGirl.create(:user) }

  let(:params) do
    { id: "#{user.id}",
      user: {}
    }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('Id is required')
    expect(errors).to include('User is required')
  end

  it 'updates user featured image via URL' do
    VCR.use_cassette('mutations/users/update_user') do
      featured_image = 'http://i.imgur.com/2haLt4J.jpg'
      image_params = params.merge(featured_image: featured_image)
      results = mutation.run(image_params)
      expect(results.success?).to eq(true)
    end
  end
end
