json.array! @baking_slots do |baking_slot|
  json.id baking_slot.id
  json.slot baking_slot.slot.strftime("%B, %d, %Y %I:%M%p")
  json.slot_count baking_slot.slot_count
  json.max_slots baking_slot.max_slots
end
