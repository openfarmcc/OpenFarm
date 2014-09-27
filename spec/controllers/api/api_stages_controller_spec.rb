require 'spec_helper'

describe Api::StagesController, type: :controller do

  include ApiHelpers

  let(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  let(:guide) { FactoryGirl.create(:guide, user: user) }
  let(:stage) { FactoryGirl.create(:stage, guide: user) }

  before do
    @guide = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
  end

  it 'creates stages'

  it 'create stage should return an error when wrong info is passed'

  it 'should show a specific stage'

  it 'should return a not found error if a guide isn\'t found'

  it 'should update a stage'

  it 'should not update a stage on someone elses guide'

end
