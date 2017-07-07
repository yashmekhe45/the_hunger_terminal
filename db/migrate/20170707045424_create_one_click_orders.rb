class CreateOneClickOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :one_click_orders do |t|
      t.string :token

      t.timestamps
    end
    add_index :one_click_orders, :token, unique: true
  end
end
