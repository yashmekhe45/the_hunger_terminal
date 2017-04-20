class CreateTerminalReports < ActiveRecord::Migration[5.0]
  def change
    create_table :terminal_reports do |t|
      t.string :name
      t.float :current_amount
      t.float :payment_made
      t.float :payable
      t.string :payment_made_by

      t.timestamps
    end
  end
end
