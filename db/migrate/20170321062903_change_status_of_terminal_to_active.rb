class ChangeStatusOfTerminalToActive < ActiveRecord::Migration[5.0]
  def change
    change_column :terminals, :is_active, :boolean, default: true 
  end
end
