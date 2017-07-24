class AddGstinToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :gstin, :string
  end
end
