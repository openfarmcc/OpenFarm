FactoryGirl.define do
  factory :action_option do
    name             { "#{Faker::Name.last_name}" }
    description      { Faker::Lorem.sentence }
  end
end
