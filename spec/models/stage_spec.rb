require 'spec_helper'

describe Stage do
  it 'has its own find method that looks inside all stages' do
    stage = FactoryGirl.create(:stage)
    FactoryGirl.create(:stage)
    sa = FactoryGirl.create(:stage_action, stage: stage)

    found_stage_action = StageAction.find("#{sa._id}")
    expect(sa._id).to eq(found_stage_action._id)
  end
end
