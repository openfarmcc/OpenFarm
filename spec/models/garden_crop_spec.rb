require 'spec_helper'

describe GardenCrop do
  it 'creates a garden crop' do
    guide = FactoryGirl.create(:guide)
    garden = FactoryGirl.create(:garden, user: FactoryGirl.create(:user))
    gc = GardenCrop.new(sowed: Date.today,
                        garden: garden,
                        guide: guide,
                        quantity: rand(100))
    gc.save
    expect(gc.garden.id).to eq(garden.id)
    expect(gc.persisted?).to eq(true)
  end

  it 'increments count in garden_crop history tracking' do
    garden = FactoryGirl.create(:garden)
    garden_crop = garden.garden_crops.create
    count = garden_crop.history_tracks.count
    number = count + 1
    garden_crop.update_attributes(stage: "I'm a new stage")
    expect(garden_crop.history_tracks.count).to eq(number)
  end

  it 'reindexes guides' do
    pending "this test does not pass on CI - RickCarlino"
    FactoryGirl.create(:guide)

    expect_any_instance_of(Guide).to receive(:reindex_async)

    FactoryGirl.create(:user)
  end
end
