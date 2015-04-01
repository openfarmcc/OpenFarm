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

  it 'reindexes guides' do
    FactoryGirl.create(:guide)

    expect_any_instance_of(Guide).to receive(:reindex_async)

    FactoryGirl.create(:garden, user: FactoryGirl.create(:user))
  end
end
