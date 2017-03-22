class DefalutStatusOfMenuItemShouldAvailable < ActiveRecord::Migration[5.0]
  def change
    change_column :menu_items, :available, :boolean, default: true
  end
end
