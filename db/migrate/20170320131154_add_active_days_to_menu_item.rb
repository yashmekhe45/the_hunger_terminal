class AddActiveDaysToMenuItem < ActiveRecord::Migration[5.0]
  def change
    add_column :menu_items, :active_days, :string,  array: true, default: []
  end
end
