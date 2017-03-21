class AddTerminalReferenceToOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :terminal, foreign_key: true, index: true
  end
end
