# frozen_string_literal: true
# Read about factories at https://github.com/thoughtbot/factory_girl
svg = File.read('./spec/fixtures/cantaloupe.svg')

FactoryGirl.define do
  factory :icon do
    name             { [*(0..2)].map { Faker::Lorem.word }.join(' ') }
    description      { Faker::Matz.quote }
    svg              svg
    user
  end
end
