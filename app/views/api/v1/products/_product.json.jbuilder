json.id product.id
json.name product.name
json.order_items do
  json.array! product.order_items, partial: "api/v1/order_items/order_item", as: :order_item
end
