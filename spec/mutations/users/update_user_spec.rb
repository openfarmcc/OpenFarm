require 'spec_helper'

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
    puts result.errors.message_list
  end
end
