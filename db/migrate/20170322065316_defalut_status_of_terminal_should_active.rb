class DefalutStatusOfTerminalShouldActive < ActiveRecord::Migration[5.0]
  def change
   change_column :terminals, :active, :boolean, default: true 
  end
end
