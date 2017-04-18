class AddTaxToTerminals < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :tax, :string
  end
end
