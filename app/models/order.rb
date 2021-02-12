class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  def allocated?
    order_items.all? { |item| item.status == ORDER_STATUS[:allocated] }
  end

  def baking_slot
    order_items.first.baking_slot if allocated?
  end

  def order_breakdown
    order_hash = Hash.new(0)
    order_items.each do |item|
      order_hash[item.product.name] += 1
    end
    order_hash
  end
end
