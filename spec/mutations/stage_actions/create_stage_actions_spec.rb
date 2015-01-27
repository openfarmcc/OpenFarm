require 'spec_helper'
require 'openfarm_errors'

describe StageActions::CreateStageAction do
  let(:mutation) { StageActions::CreateStageAction }
  let(:stage) { FactoryGirl.create(:stage) }
  let(:params) do
    { user: stage.guide.user,
      id: "#{stage._id}",
      action: { name: "#{Faker::Name.last_name}",
                overview: "#{Faker::Lorem.paragraph}" } }
  end

  it 'minimally runs the mutation' do
    results = mutation.run(params)
    expect(results.success?).to be_truthy
  end

  it 'disallows making actions for stages that are not a users' do
    user = FactoryGirl.create(:user)
    params[:user] = user
    expect { mutation.run(params) }.to raise_exception
  end

  it 'disallows making actions for stages that do not exist' do
    params[:id] = '1'
    results = mutation.run(params)
    expect(results.success?).to be_falsey
    expect(results.errors.message_list).to include('Could not find a stage '\
                                                   'with id 1.')
  end
end
