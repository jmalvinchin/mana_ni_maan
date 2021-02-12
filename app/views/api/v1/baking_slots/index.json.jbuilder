json.array! @baking_slots do |baking_slot|
  json.id baking_slot.id
  json.slot baking_slot.slot.strftime("%B, %d, %Y %I:%M%p")
end
