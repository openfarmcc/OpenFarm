# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :requirement_option_range, class: 'RequirementOption' do
    name { "#{Faker::Name.last_name}" }
    description { Faker::Lorem.sentence }
    type { 'range' }
    # TODO: this could be much more sophisticated
    options { [rand(1..5), rand(5..20), rand(1)] }
  end
end
