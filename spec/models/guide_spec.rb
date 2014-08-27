require 'spec_helper'

describe Guide do
  it 'requires a user, crop and name' do
    guide = Guide.new
    errors = guide.errors.messages
    expect(guide).to_not be_valid
    expect(errors[:name]).to include("can't be blank")
    expect(errors[:user]).to include("can't be blank")
    expect(errors[:crop]).to include("can't be blank")
  end
end
