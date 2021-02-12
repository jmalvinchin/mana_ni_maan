FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    channel { ["facebook", "instagram", "forms"].sample }
  end
end
