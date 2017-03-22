class AddColumnDescriptionToMenuItem < ActiveRecord::Migration[5.0]
  def change       
    add_column :menu_items, :description, :text
  end
end
