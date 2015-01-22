require 'spec_helper'

describe Gardens::DestroyGarden do
  let(:mutation) { Gardens::DestroyGarden }

  let(:garden) { FactoryGirl.create(:garden) }

  let(:params) do
    { user: garden.user,
      id: "#{garden._id}" }
  end

  it 'requires fields' do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include('User is required')
    expect(errors).to include('Id is required')
  end

  it 'checks that a garden with the required id exists' do
    params[:id] = 1
    outcome = mutation.run(params)
    expect(outcome.success?).to be_false
    expect(outcome.errors.message_list)
      .to include("Could not find a garden with id #{params[:id]}.")
  end

  # We can't test for mutations that include the openfarm error
  # because it's defined outside of the scope of the standalone
  # mutation?
end
