class AddColumnMinOrderAmountToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :min_order_amount, :float
  end
end
