class Order < ApplicationRecord
  belongs_to :customer, class_name: "User", foreign_key: "user_id"
  has_many :order_items

  def allocated?
    order_items.all? { |item| item.status == ORDER_STATUS[:allocated] }
  end

  def baking_slot
    order_items.first.baking_slot if allocated?
  end
end
