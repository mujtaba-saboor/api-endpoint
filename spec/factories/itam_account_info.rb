FactoryBot.define do
  factory :itam_account_info do
    access_token { Faker::Alphanumeric.alpha(number: 32) }
  end
end
