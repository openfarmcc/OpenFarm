FactoryGirl.define do
  factory :user do
    email           { Faker::Internet.email }
    display_name    { Faker::Name.name }
    location        { "#{Faker::Address.city_prefix}, #{Faker::Address.state}" }
    years_experience { (rand(9) + rand(9)) + 1 }
    password_confirmation(&:password)
    admin false
    password 'password'
    is_private false
    trait :admin do
      admin :false
    end
    trait :is_private do
      is_private :true
    end
  end
end
