class RenamePaybleToPayable < ActiveRecord::Migration[5.0]
  def change
    rename_column :terminals, :payble, :payable
  end
end
