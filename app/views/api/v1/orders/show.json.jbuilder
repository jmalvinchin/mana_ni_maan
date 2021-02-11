json.id @order.id
json.baking_slot @order.baking_slot, :id, :slot_count, :max_slots
json.customer do
  json.id @order.customer.id
  json.first_name @order.customer.first_name
  json.last_name @order.customer.last_name
end
json.order_items do
  json.array! @order.order_items, partial: "api/v1/order_items/order_item", as: :order_item
end

json.order_breakdown(@order.order_breakdown) do |breakdown|
  json.set! :name, "#{breakdown[0]}"
  json.set! :quantity, "#{breakdown[1]}"
end
