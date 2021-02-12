class BakingSlot < ApplicationRecord
  include Filterable
  has_many :order_items

  validates :slot, presence: true

  scope :filer_by_slot, -> (slot) { where(slot: slot) }
end
