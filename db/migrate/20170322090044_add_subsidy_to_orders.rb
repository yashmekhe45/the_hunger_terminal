class AddSubsidyToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :orders, :float
  end
end
