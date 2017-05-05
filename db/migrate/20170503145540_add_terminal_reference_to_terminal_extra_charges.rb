class AddTerminalReferenceToTerminalExtraCharges < ActiveRecord::Migration[5.0]
  def change
    add_reference :terminal_extra_charges, :terminal, foreign_key: true, index: true 
  end
end
