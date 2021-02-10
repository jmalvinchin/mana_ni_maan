class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :baking_slot, null: true, foreign_key: true
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
