FactoryBot.define do
  factory :order do
    slot_count { 1 }
    paid { true }
    customer
  end
end
