class RemoveTerminalReferenceFrom < ActiveRecord::Migration[5.0]
  def change
    remove_reference(:order_details, :terminal, index: true, foreign_key: true)
  end
end
