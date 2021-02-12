class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :reference_code
      t.integer :slot_count, default: 0
      t.boolean :paid
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
