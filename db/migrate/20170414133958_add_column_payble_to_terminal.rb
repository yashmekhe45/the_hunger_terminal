class AddColumnPaybleToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :payble, :float, default: 0
  end
end
