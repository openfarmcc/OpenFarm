require 'spec_helper'
require 'openfarm_errors'

describe Users::UpdateUser do
  let(:mutation) { Users::UpdateUser }

  let(:other_user) { FactoryBot.create(:user) }
  let(:current_user) { FactoryBot.create(:user) }
  let(:crop) { FactoryBot.create(:crop) }

  let(:params) do
    { id: "#{current_user.id}",
      attributes: {
        mailing_list: false
      },
      current_user: current_user
    }
  end
  let(:params_with_usersetting) do
    { id: "#{current_user.id}",
      attributes: {},
      user_setting: {
        location: "Manila"
      },
      current_user: current_user
    }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('Id is required')
    expect(errors).to include('Attributes is required')
    expect(errors).to include('Current User is required')
  end

  it 'updates user featured image via URL' do
    VCR.use_cassette('mutations/users/update_user') do
      featured_image = {
        image_url: 'http://i.imgur.com/2haLt4J.jpg'
      }
      image_params = params.merge(pictures: [featured_image])
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
    result = mutation.run(params_with_usersetting).result
    expect(result).to be_a(User)
    expect(result.user_setting.location).to eq("Manila")
    expect(result.valid?).to be(true)
  end

  it 'adds valid favorite guides' do
    guide = FactoryBot.create(:guide)
    params[:attributes][:favorited_guide_ids] = ["#{guide._id}"]
    result = mutation.run(params)
    expect(result.success?).to be(true)
    expect(result.result.favorited_guide_ids.length).to be(1)
    expect("#{result.result.favorited_guide_ids[0]}").to eq("#{guide._id}")
  end

  it 'rejects invalid favorite guides' do
    params[:attributes][:favorited_guide_ids] = ['123']
    result = mutation.run(params)
    expect(result.success?).to be(false)
    expect(result.errors).to include('favorited_guide_ids')
    expect(result.errors['favorited_guide_ids'].message).to include('123')
  end

  it 'doesnt remove user featured image when sending no featured_image'

  it 'does not add favorited guides that are already favorited' do
    guide = FactoryBot.create(:guide)
    params[:attributes][:favorited_guide_ids] = ["#{guide._id}", "#{guide._id}"]
    result = mutation.run(params)
    expect(result.success?).to be(true)
    expect(result.result.favorited_guide_ids.length).to be(1)
    expect("#{result.result.favorited_guide_ids[0]}").to eq("#{guide._id}")
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

  it 'rejects users without a valid featured image' do
    params[:pictures] = [{
      image_url: 'not/absoloute.png'
    }]
    VCR.use_cassette('mutations/users/update_user_invalid_pic.rb') do
      result = mutation.run(params)
      expect(result.success?).to be(false)
      expect(result.errors.message_list.first).to include('is not a valid URL')
    end
  end

  it 'handles users that have an existing image when image already exists' do
    VCR.use_cassette('mutations/users/update_user_existing_image.rb') do
      current_user.user_setting.pictures = [Picture.new(
        attachment: open('http://i.imgur.com/2haLt4J.jpg')
      )]
      featured_image = [{ image_url: 'http://i.imgur.com/2haLt4J.jpg' }]
      image_params = params.merge(featured_image: featured_image)
      results = mutation.run(image_params)
      expect(results.success?).to eq(true)
    end
  end

  it 'handles sending an empty user featured_image' do
    VCR.use_cassette('mutations/users/update_user_remove_image.rb') do
      current_user.user_setting.pictures = [Picture.new(
        attachment: open('http://i.imgur.com/2haLt4J.jpg')
      )]
      featured_image = []
      image_params = params.merge(featured_image: featured_image)
      results = mutation.run(image_params)
      expect(results.success?).to eq(true)
      expect(current_user.reload.user_setting.pictures.first).to eq(nil)
    end
  end
end
