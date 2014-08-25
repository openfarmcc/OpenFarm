require 'spec_helper'

describe Crop do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:crop)).to be_valid
  end

  it 'requires a name' do
    expect(Crop.create(name: nil)).to_not be_valid
  end

  context '#full_text_search' do

    let!(:crop) { FactoryGirl.create(:crop, :radish) }

    it 'searches by name' do
      result = Crop.full_text_search('Common Horseradish').first
      expect(result).to eq(crop)
    end

    it 'searches by binomial name' do
      expect(Crop.full_text_search('Armoracia rusticana').first).to eq(crop)
    end

    it 'searches by description' do
      expect(Crop.full_text_search('Brassicaceae family').first).to eq(crop)
    end
  end
end
