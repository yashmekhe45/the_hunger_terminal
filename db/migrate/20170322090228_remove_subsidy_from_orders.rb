class RemoveSubsidyFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :orders, :float
  end
end
