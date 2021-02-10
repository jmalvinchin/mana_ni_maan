class CreateBakingSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :baking_slots do |t|
      t.datetime :slot
      t.integer :slot_count, default: 0
      t.integer :max_slots

      t.timestamps
    end
  end
end
