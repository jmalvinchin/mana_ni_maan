FactoryBot.define do
  factory :baking_slot do
    slot { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1.year) }
  end
end
