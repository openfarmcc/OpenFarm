require 'spec_helper'

describe Crop do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:crop)).to be_valid
  end

  it 'requires a name' do
    expect(Crop.create(name: nil)).to_not be_valid
  end

  context '#search' do

    let!(:crop) { FactoryGirl.create(:crop, :potato) }

    # Pending tests
  end
end
