FactoryBot.define do
  factory :order_item do
    status { ORDER_STATUS[:pending] }
    baking_slot
    order
    product
  end
end
