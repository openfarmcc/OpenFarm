# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :crop do
    crop_data_source
    name { "#{Faker::Commerce.color} #{Faker::Name.last_name}" }
    binomial_name { Faker::Lorem.words(2).join(' ') }
    description { Faker::Lorem.sentence }
    sun_requirements { %w[full shade].sample }
    sowing_method { %w[container direct].sample }
    spread { rand(10) + rand(10) + 1 }
    row_spacing { rand(10) + rand(10) + 1 }
    height { rand(10) + rand(10) + 1 }
    trait :radish do
      name { 'Common Horseradish' }
      binomial_name { 'Armoracia rusticana' }
      description { 'Brassicaceae family' }
    end
  end
end
