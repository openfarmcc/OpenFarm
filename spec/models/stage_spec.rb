require 'spec_helper'

describe Stage do
  it 'has its own find method that looks inside all stages' do
    stage = FactoryBot.create(:stage)
    FactoryBot.create(:stage)
    sa = FactoryBot.create(:stage_action, stage: stage)

    found_stage_action = StageAction.find("#{sa._id}")
    expect(sa._id).to eq(found_stage_action._id)
  end
end
