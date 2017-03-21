class RemoveColumnVegFromOrderDetail < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_details, :veg
  end
end
