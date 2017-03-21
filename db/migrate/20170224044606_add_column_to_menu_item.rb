class AddColumnToMenuItem < ActiveRecord::Migration[5.0]
  def change
    add_column :menu_items, :is_active, :boolean
  end
end
