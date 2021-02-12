# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

slot1 = BakingSlot.create(slot: DateTime.now + 1.year, slot_count: 3, max_slots: 5)

product1 = Product.create(name: "Apple Cinnamon")
product2 = Product.create(name: "Dark Fudge")

customer1 = Customer.create(first_name: "John", last_name: "Doe")
customer2 = Customer.create(first_name: "Jane", last_name: "Doe")

order1 = Order.create(
  slot_count: 2,
  customer: customer1,
  paid: true,
)
order1_oi1 = OrderItem.create(
  order: order1,
  baking_slot: slot1,
  status: "allocated",
  product: product1
)
order1_oi2 = OrderItem.create(
  order: order1,
  baking_slot: slot1,
  status: "allocated",
  product: product2
)

order2 = Order.create(
  slot_count: 1,
  customer: customer2,
  paid: true,
)
order2_oi1 = OrderItem.create(
  order: order2,
  baking_slot: slot1,
  status: "allocated",
  product: product1
)

order3 = Order.create(
  slot_count: 1,
  customer: customer2,
  paid: false,
)
order2_oi1 = OrderItem.create(
  order: order2,
  baking_slot: slot1,
  status: "pending",
  product: product1
)
