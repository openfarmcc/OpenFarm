FactoryGirl.define do
  factory :user do
    email_address 'test@openfarm.cc'
    display_name  'Test user'
    location      'Morgantown, WV'
    soil_type     'Dirty'
    preferred_growing_style 'Ground'
    years_experience  1
    password       'password'
    password_confirmation { |u| u.password }
  end
end