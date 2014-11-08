# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    name             { "#{Faker::Commerce.color} #{Faker::Name.last_name}" }
    days_start       { rand(360) }
    days_end         { rand(360) }
    instructions     { Faker::Lorem.paragraph }
    guide
  end
end
