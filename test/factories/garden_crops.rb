# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :garden_crop do
    quantity { rand(100) }
    sowed { Faker::Date.between(2.days.ago, Date.today) }
    stage
    garden
    guide
  end
end
