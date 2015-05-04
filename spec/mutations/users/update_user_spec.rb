require 'spec_helper'
require 'openfarm_errors'

# module OpenfarmErrors
#   class NotAuthorized < StandardError; end
#   class StaleToken < StandardError; end
# end

describe Users::UpdateUser do
  let(:mutation) { Users::UpdateUser }

  let(:other_user) { FactoryGirl.create(:user) }
  let(:current_user) { FactoryGirl.create(:user) }
  let(:crop) { FactoryGirl.create(:crop) }

  let(:params) do
    { id: "#{current_user.id}",
      user: {
        mailing_list: false
      },
      current_user: current_user
    }
  end
  let(:params_with_usetting) do
    { id: "#{current_user.id}",
      user: {},
      user_setting: {
        location: "Manila"
      },
      current_user: current_user
    }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('Id is required')
    expect(errors).to include('User is required')
    expect(errors).to include('Current User is required')
  end

  it 'updates user featured image via URL' do
    VCR.use_cassette('mutations/users/update_user') do
      featured_image = 'http://i.imgur.com/2haLt4J.jpg'
      image_params = params.merge(featured_image: featured_image)
      results = mutation.run(image_params)
      expect(results.success?).to eq(true)
    end
  end

  it 'updates valid users' do
    result = mutation.run(params).result
    expect(result).to be_a(User)
    expect(result.valid?).to be(true)
  end

  it 'updates valid user_setting' do
    result = mutation.run(params_with_usetting).result
    expect(result).to be_a(User)
    expect(result.user_setting.location).to eq("Manila")
    expect(result.valid?).to be(true)
  end

  it 'updates valid favorite_crop' do
    params[:user_setting] = {
      favorite_crop: "#{crop.id}"
    }
    result = mutation.run(params).result
    expect(result).to be_a(User)
    expect(result.user_setting.favorite_crops[0].name).to eq(crop.name)
    expect(result.valid?).to be(true)
  end

  it 'rejects invalid favorite_crop' do
    params[:user_setting] = {
      favorite_crop: 'bla'
    }

    result = mutation.run(params)
    expect(result.success?).to be(false)
    expect(result.errors.message_list).to include('Could not find a crop with id ')
  end

  it 'rejects users that are not themselves' do
    params['current_user'] = other_user
    expect do
      result = mutation.run(params)
    end.to raise_exception(OpenfarmErrors::NotAuthorized)
  end
end
