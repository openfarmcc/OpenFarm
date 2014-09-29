require 'spec_helper'

describe Api::RequirementOptionsController, type: :controller do
  include ApiHelpers

  let(:user) {sign_in(user = FactoryGirl.create(:user)) && user }
  let(:requirement_option) { FactoryGirl.create(:requirement_option) }
  
  before do
    FactoryGirl.create_list(:requirement_option, 2)
  end

  it 'lists requirement options' do
    get 'index', format: :json
    expect(response.status).to eq(200)
    expect(json['requirement_options'].length).to eq(RequirementOption.all.length)
  end

end