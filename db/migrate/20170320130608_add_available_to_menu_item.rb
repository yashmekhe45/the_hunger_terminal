class AddAvailableToMenuItem < ActiveRecord::Migration[5.0]
  def change
    add_column :menu_items, :available, :boolean
  end
end
