class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :baking_slot, optional: true
  has_one :order_items_products
  has_one :product, through: :order_items_products
end
