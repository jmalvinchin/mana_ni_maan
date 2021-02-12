class Order < ApplicationRecord
  include Filterable

  belongs_to :customer
  has_many :order_items
  before_save :generate_reference_code

  validates :reference_code, uniqueness: true

  scope :filter_by_reference_code, -> (code) { where(reference_code: code) }
  scope :filter_by_slot_count, -> (slot_count) { where(slot_count: slot_count) }
  scope :filter_by_paid, -> (paid) { where(paid: paid) }
  scope :filter_by_customer_id, -> (customer_id) { where(customer_id: customer_id) }

  def self.filter_by_allocated(value)
    joins(:order_items).where("order_items.status": ORDER_STATUS[:allocated])
  end

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
