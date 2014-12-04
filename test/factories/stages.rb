# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    name             { "#{Faker::Name.last_name}" }
    length           { rand(360) }
    soil             { [Faker::Lorem.word] }
    where            { [Faker::Lorem.word] }
    light            { [Faker::Lorem.word] }
    guide
  end
end
