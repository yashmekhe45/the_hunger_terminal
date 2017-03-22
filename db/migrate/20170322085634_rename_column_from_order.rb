class RenameColumnFromOrder < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :subsidy, :discount
  end
end
