class AddColumnCurrentAmountToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :current_amount, :float, default: 0
  end
end
