# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :action do
    name             { "#{Faker::Name.last_name}" }
    overview         { Faker::Lorem.paragraph }
  end
end
