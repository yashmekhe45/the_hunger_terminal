class AddDateColumnToTerminalExtraCharge < ActiveRecord::Migration[5.0]
  def change
    add_column :terminal_extra_charges, :date, :date
  end
end
