# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :stage do
    name             { Faker::Name.last_name }
    stage_length     { rand(360) }
    soil             { [Faker::Lorem.word] }
    environment      { [Faker::Lorem.word] }
    light            { [Faker::Lorem.word] }
    guide
  end
end
