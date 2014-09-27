require 'spec_helper'

describe Api::StagesController, type: :controller do

  include ApiHelpers

  let(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  let(:guide) { FactoryGirl.create(:guide, user: user) }
  let(:requirement) { FactoryGirl.create(:requirement, guide: user) }

  before do
    @guide = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
  end

  it 'creates requirements'

  it 'deletes requirements'

  it 'should return an error when wrong info is passed to create'

  it 'should show a specific requirements'

  it 'should return a not found error if a guide isn\'t found'

  it 'should update a requirement'

  it 'should not update a requirement on someone elses guide'

end
