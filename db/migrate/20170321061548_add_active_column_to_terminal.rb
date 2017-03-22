class AddActiveColumnToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :active, :boolean
  end
end
