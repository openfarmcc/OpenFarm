FactoryGirl.define do
  factory :user do
    email           { Faker::Internet.email }
    display_name    { Faker::Name.name }
    location        { "#{Faker::Address.city_prefix}, #{Faker::Address.state}" }
    soil_type       { ['Dirty', 'loamy', 'clay', 'rocky'].sample }
    years_experience { (rand(9) + rand(9)) + 1}
    password_confirmation { |u| u.password }
    admin false
    preferred_growing_style 'Ground'
    password 'password'
  end
end
