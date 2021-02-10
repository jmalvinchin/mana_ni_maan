FactoryBot.define do
  factory :product do
    name { "#{Faker::Dessert.flavor} #{Faker::Dessert.variety}" }
  end
end
