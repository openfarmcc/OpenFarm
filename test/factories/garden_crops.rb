# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :garden_crop do
    quantity    { rand(100) }
    # Question for code review: Should this be a relation instead?
    stage       { "#{Faker::Lorem.word}" }
    sowed       { Faker::Date.between(2.days.ago, Date.today) }
    garden
    guide
  end
end
