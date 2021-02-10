class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :baking_slot
  has_one :order_item_product
  has_one :product, through: :order_item_product
end
