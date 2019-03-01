require 'spec_helper'

describe Api::V1::StageOptionsController, type: :controller do
  include ApiHelpers

  let(:user) {sign_in(user = FactoryBot.create(:user)) && user }
  let(:stage_option) { FactoryBot.create(:stage_option) }

  before do
    FactoryBot.create_list(:stage_option, 2)
  end

  it 'lists requirement options' do
    get 'index', params: { format: :json }
    expect(response.status).to eq(200)
    expect(json['data'].length).to eq(StageOption.all.length)
  end
end
