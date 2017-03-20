class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
      t.integer :quantity
      t.string :menu_item_name
      t.float :menu_item_price
      t.boolean :veg
      t.string :terminal_name
      t.references :menu_item, foreign_key: true
      t.references :order, foreign_key: true
      t.references :terminal, foreign_key: true

      t.timestamps
    end
  end
end
