# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :requirement_option_select, class: 'RequirementOption' do
    name             { "#{Faker::Name.last_name}" }
    description      { Faker::Lorem.sentence }
    type             { 'select' }
    # TODO: this could be much more sophisticated
    options          { [Faker::Lorem.word, Faker::Lorem.word] }
  end
end
