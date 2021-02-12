class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  before_save :generate_reference_code

  validates :reference_code, uniqueness: true

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

  private

  def generate_reference_code
    loop do
      self.reference_code = SecureRandom.hex(3).upcase
      break if Order.find_by(reference_code: reference_code).nil?
    end
  end
end
