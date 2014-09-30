require 'spec_helper'

describe Api::StageOptionsController, type: :controller do
  include ApiHelpers

  let(:user) {sign_in(user = FactoryGirl.create(:user)) && user }
  let(:stage_option) { FactoryGirl.create(:stage_option) }
  
  before do
    FactoryGirl.create_list(:stage_option, 2)
  end

  it 'lists requirement options' do
    get 'index', format: :json
    expect(response.status).to eq(200)
    expect(json['stage_options'].length).to eq(StageOption.all.length)
  end

end