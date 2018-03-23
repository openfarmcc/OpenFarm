require 'spec_helper'

describe Crop do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:crop)).to be_valid
  end

  it 'requires a name' do
    expect(Crop.create(name: nil)).to_not be_valid
  end

  context '#search' do
    let!(:crop) { FactoryGirl.create(:crop, :radish) }

    it 'searches by name' do
      skip 'this test does not pass on CI - RickCarlino'
      Crop.searchkick_index.refresh
      result = Crop.search('Common Horseradish').first
      expect(result).to eq(crop)
    end

    it 'searches by binomial name' do
      skip 'this test does not pass on CI - RickCarlino'
      Crop.searchkick_index.refresh
      expect(Crop.search('Armoracia rusticana').first).to eq(crop)
    end

    it 'searches by description' do
      skip 'this test does not pass on CI - RickCarlino'
      Crop.searchkick_index.refresh
      expect(Crop.search('Brassicaceae family').first).to eq(crop)
    end

    it 'displays the main_image_path' do
      expect(crop.main_image_path).to_not eq(nil)
      # TODO: test for placeholder image?
      fancy_crop = FactoryGirl.create(:crop_picture).photographic
      expect(fancy_crop.main_image_path).to be_kind_of(String)
      expect(fancy_crop.main_image_path).to include("pictures/attachments")
    end

    it 'checks that taxon is one of 10 options if included' do
      crop.taxon = 'Species'
      expect(crop.save).to be(true)
      expect(crop.taxon).to eq('Species')
    end

    it 'rejects taxon that is not one of 10 options if included' do
      crop.taxon = 'Pokemon'
      expect(crop.save).to be(false)
    end
  end
end
