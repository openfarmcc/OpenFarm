FactoryGirl.define do
  factory :user do
    email           { Faker::Internet.email }
    display_name    { Faker::Name.name }
    location        { "#{Faker::Address.city_prefix}, #{Faker::Address.state}" }
    years_experience { (rand(9) + rand(9)) + 1}
    password_confirmation { |u| u.password }
    admin false
    password 'password'
    is_private false
    confirmed_at { Faker::Date.between(2.days.ago, Date.today) }
    trait :admin do
      admin :false
    end
    trait :is_private do
      is_private :true
    end
  end
end
