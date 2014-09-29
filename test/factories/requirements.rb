# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :requirement do
    name             { "#{Faker::Commerce.color} #{Faker::Name.last_name}" }
    required         { Faker::Lorem.words(2) }
    guide
  end
end
