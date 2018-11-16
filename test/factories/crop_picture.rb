# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :crop_picture, class: Picture do
    # First seen here:
    # marygriffith1743.deviantart.com/art/
    # this-is-how-i-looked-yesterday-for-six-whole-hours-328072554
    attachment File.open('spec/fixtures/cat.jpg')
    photographic  { FactoryBot.build(:crop) }
  end
end
