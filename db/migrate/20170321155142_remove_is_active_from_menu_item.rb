class RemoveIsActiveFromMenuItem < ActiveRecord::Migration[5.0]
  def change
    remove_column :menu_items, :is_active
  end
end
