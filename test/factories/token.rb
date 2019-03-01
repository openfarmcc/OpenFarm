FactoryBot.define do
  factory :token do
    user

    after(:create) { |token| token.user.confirm }
  end
end
