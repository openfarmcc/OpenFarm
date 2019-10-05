# frozen_string_literal: true

FactoryBot.define do
  factory :detail_option do
    name { "#{Faker::Name.last_name}" }
    description { Faker::Lorem.sentence }
    help { Faker::Lorem.sentence }
    category { "#{Faker::Lorem.word}" }
  end
end
