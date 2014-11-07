# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :garden do
    name        { "#{Faker::Commerce.color} #{Faker::Name.last_name}" }
    description { Faker::Lorem.sentence }
    location    { "#{Faker::Address.city_prefix}, #{Faker::Address.state}" }
    type        { Faker::Lorem.word }
    soil_type   { Faker::Lorem.word }
    is_private false
    user
  end
end
