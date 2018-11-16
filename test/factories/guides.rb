# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :guide do
    name             { "#{Faker::Commerce.color} #{Faker::Name.last_name}" }
    overview         { Faker::Lorem.sentence }
    impressions_field { rand(100) }
    crop
    user
    trait :radish do
      name 'Common Horseradish Guide'
      binomial_name 'Armoracia rusticana'
      description 'Brassicaceae family'
    end
  end
end
