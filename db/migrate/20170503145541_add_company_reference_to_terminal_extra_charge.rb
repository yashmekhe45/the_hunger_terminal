class AddCompanyReferenceToTerminalExtraCharge < ActiveRecord::Migration[5.0]
  def change
    add_reference :terminal_extra_charges, :company, foreign_key: true, index: true
  end
end
