class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
      t.references :order, foreign_key: true
      t.references :terminal, foreign_key: true
      t.string :menu_item_name
      t.integer :price
      t.integer :quantity
      t.boolean :veg

      t.timestamps
    end
  end
end
