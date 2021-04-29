FactoryBot.define do
  factory :api_company do
    itam_company_id { Faker::Number.number(digits: 2) }
    access_token { Faker::Alphanumeric.alpha(number: 32) }
  end
end
