# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :garden_crop do
    quantity    { rand(100) }
    stage       { "#{Faker::Lorem.word}" }
    sowed       { Date.parse("#{Faker::Date.between(2.days.ago, Date.today)}") }
    garden
    guide
  end
end
