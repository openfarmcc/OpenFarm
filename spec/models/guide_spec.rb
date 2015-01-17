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

  it 'checks ownership with #owned_by()' do
    guide = FactoryGirl.create(:guide)
    other_user = FactoryGirl.create(:user)
    expect(guide.owned_by?(guide.user)).to eq(true)
    expect(guide.owned_by?(nil)).to eq(false)
    expect(guide.owned_by?(other_user)).to eq(false)
  end

  it 'has implemented a real compatibility label' do
    guide = FactoryGirl.build(:guide)

    guide.stub(:compatibility_score).and_return 80
    expect(guide.compatibility_label).to eq('high')

    guide.stub(:compatibility_score).and_return 60
    expect(guide.compatibility_label).to eq('medium')

    guide.stub(:compatibility_score).and_return 20
    expect(guide.compatibility_label).to eq('low')

    guide.stub(:compatibility_score).and_return nil
    expect(guide.compatibility_label).to eq('')
  end

  it 'creates a basic_needs array if a user has a garden' do
    user = FactoryGirl.build(:user)
    FactoryGirl.build(:garden,
                      user: user,
                      soil_type: 'Loam',
                      type: 'Outside',
                      average_sun: 'Partial Sun')
    guide = Guide.new(user: user)
    Stage.new(guide: guide,
              environment: ['Outside'],
              soil: ['Clay'],
              light: ['Partial Sun'])
    expect(guide.compatibility_score.round).to eq(50)
  end

  it 'returns 0 percent if there are no basic_needs for a guide' do
    user = FactoryGirl.build(:user)
    FactoryGirl.build(:garden,
                      user: user,
                      soil_type: 'Loam',
                      type: 'Outside',
                      average_sun: 'Partial Sun')
    guide = Guide.new(user: user)
    Stage.new(guide: guide,
              environment: [],
              soil: [],
              light: [])
    expect(guide.compatibility_score.round).to eq(0)
  end

  it 'returns nil from basic_needs if a user has no garden' do
    guide = FactoryGirl.build(:guide)
    Stage.new(guide: guide,
              environment: ['Outside'],
              soil: ['Clay'],
              light: ['Partial Sun'])
    expect(guide.compatibility_score).to eq(nil)
  end
end
