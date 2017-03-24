class RemoveIsActiveFromTerminal < ActiveRecord::Migration[5.0]
  def change
    remove_column :terminals, :is_active
  end
end
