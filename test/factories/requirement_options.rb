# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :requirement_option do
    name             { "#{Faker::Commerce.color} #{Faker::Name.last_name}" }
    description      { Faker::Lorem.sentence }
    type             { ['select', 'range'].sample }
    # TODO: this could be much more sophisticated
    options          { [[Faker::Lorem.words(1), Faker::Lorem.words(1)], 
                        [rand(10), rand(10), rand(5)]].sample}   
  end
end
