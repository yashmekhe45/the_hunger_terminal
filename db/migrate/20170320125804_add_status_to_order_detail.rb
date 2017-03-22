class AddStatusToOrderDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :order_details, :status, :string
  end
end
