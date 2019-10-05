# frozen_string_literal: true

FactoryBot.define do
  factory :user_setting do
    favorite_crop_ids { [] }
    location { "#{Faker::Address.city_prefix}, #{Faker::Address.state}" }
    processing_pictures { 0 }
    units { 'Imperial' }
    years_experience { (rand(9) + rand(9)) + 1 }
  end
end
