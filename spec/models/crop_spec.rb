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

    # it 'searches by name' do
    #   Crop.searchkick_index.refresh
    #   result = Crop.search('potato').first
    #   expect(result).to eq(crop)
    # end

    # it 'searches by binomial name' do
    #   Crop.searchkick_index.refresh
    #   expect(Crop.search('Solanum tuberosum').first).to eq(crop)
    # end

   
  end
end
