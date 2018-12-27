FactoryBot.define do
  factory :user do
    password_confirmation { |u| u.password }
    display_name { Faker::Name.name }
    admin        { false }
    password     { 'password' }
    is_private   { false }
    confirmed_at { Faker::Date.between(2.days.ago, Date.today) }
    email        { Faker::Internet.email }
    user_setting

    trait :admin do
      admin { :false }
    end

    trait :is_private do
      is_private { :true }
    end

    factory :confirmed_user, parent: :user do
      after(:create) { |user| user.confirm }
    end
  end
end
