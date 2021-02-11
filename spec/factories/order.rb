FactoryBot.define do
  factory :order do
    slot_count { 1 }
    paid { true }
    customer { FactoryBot.create(:user) }
  end
end
