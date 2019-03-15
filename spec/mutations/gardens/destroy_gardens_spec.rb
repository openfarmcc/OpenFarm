require "spec_helper"
require "openfarm_errors"

describe Gardens::DestroyGarden do
  let(:mutation) { Gardens::DestroyGarden }

  let(:garden) { FactoryBot.create(:garden) }

  let(:params) do
    { user: garden.user,
     id: "#{garden._id}" }
  end

  it "requires fields" do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include("User is required")
    expect(errors).to include("ID is required")
  end

  it "checks that a garden with the required id exists" do
    params[:id] = 1
    outcome = mutation.run(params)
    expect(outcome.success?).to be_falsey
    expect(outcome.errors.message_list).to include("Could not find a garden" +
                                                   " with id #{params[:id]}.")
  end

  # Test for things that use openfarm_errors
end
