class CreateTerminalExtraCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :terminal_extra_charges do |t|
      t.integer :daily_extra_charge
      t.timestamps
    end
  end
end
