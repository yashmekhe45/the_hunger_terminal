class AddTaxColumnToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :tax, :float, default: 0
  end
end
