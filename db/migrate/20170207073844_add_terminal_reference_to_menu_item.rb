class AddTerminalReferenceToMenuItem < ActiveRecord::Migration[5.0]
  def change
    add_reference :menu_items, :terminal,foreign_key: true ,index: true 
  end
end
