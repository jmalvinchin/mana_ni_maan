class CreateBakingSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :baking_slots do |t|
      t.datetime :slot

      t.timestamps
    end
  end
end
