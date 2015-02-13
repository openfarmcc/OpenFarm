require 'spec_helper'
require 'openfarm_errors'

describe Guides::DestroyGuide do
  let(:mutation) { Guides::DestroyGuide }

  let(:guide) { FactoryGirl.create(:guide) }

  let(:params) do
    { user: guide.user,
      id: "#{guide._id}" }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('User is required')
    expect(errors).to include('Id is required')
  end

  it 'checks that a guide with the required id exists' do
    params[:id] = 1
    outcome = mutation.run(params)
    expect(outcome.success?).to be_falsey
    expect(outcome.errors.message_list).to include('Could not find a guide' +
                                                   " with id #{params[:id]}.")
  end

  # Test for things that use openfarm_errors
end
