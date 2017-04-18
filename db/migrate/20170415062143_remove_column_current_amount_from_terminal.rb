class RemoveColumnCurrentAmountFromTerminal < ActiveRecord::Migration[5.0]
  def change
    remove_column :terminals, :current_amount
  end
end
