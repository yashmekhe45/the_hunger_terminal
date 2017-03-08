class AddColumnTotalPriceToOrderDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :order_details, :total_price, :integer
  end
end
