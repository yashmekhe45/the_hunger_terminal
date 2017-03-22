class AddColumnToTerminals < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :is_active, :boolean
  end
end
